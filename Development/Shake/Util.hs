
-- | A module for useful utility functions for Shake build systems.
module Development.Shake.Util(
    parseMakefile, needMakefileDependencies, neededMakefileDependencies
    ) where

import Development.Shake
import Development.Shake.Rules.File
import qualified Data.ByteString.Char8 as BS
import qualified Development.Shake.ByteString as BS
import Control.Arrow


-- | Given the text of a Makefile, extract the list of targets and dependencies. Assumes a
--   small subset of Makefile syntax, mostly that generated by @gcc -MM@.
--
-- > parseMakefile "a: b c\nd : e" == [("a",["b","c"]),("d",["e"])]
parseMakefile :: String -> [(FilePath, [FilePath])]
parseMakefile = map (BS.unpack *** map BS.unpack) . BS.parseMakefile . BS.pack


-- | Depend on the dependencies listed in a Makefile. Does not depend on the Makefile itself.
--
-- > needMakefileDependencies file = need . concatMap snd . parseMakefile =<< liftIO (readFile file)
needMakefileDependencies :: FilePath -> Action ()
needMakefileDependencies file = needBS . concatMap snd . BS.parseMakefile =<< liftIO (BS.readFile file)


-- | Depend on the dependencies listed in a Makefile. Does not depend on the Makefile itself.
--   Use this function to indicate that you have /already/ used the files in question.
--
-- > neededMakefileDependencies file = needed . concatMap snd . parseMakefile =<< liftIO (readFile file)
neededMakefileDependencies :: FilePath -> Action ()
neededMakefileDependencies file = neededBS . concatMap snd . BS.parseMakefile =<< liftIO (BS.readFile file)
