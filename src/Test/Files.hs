
module Test.Files(main) where

import Development.Shake
import Development.Shake.FilePath
import Test.Type
import Control.Monad
import Data.List
import General.GetOpt

data Args = UsePredicate deriving (Eq,Show,Bounded,Enum)

main = shakeTest optionsEnum test $ \opts -> do
    let obj = id
    want ["even.txt","odd.txt"]

    -- Since &?> and &%> are implemented separately we test everything in both modes
    let deps &?%> act | UsePredicate `elem` opts = (\x -> if x `elem` deps then Just deps else Nothing) &?> act
                      | otherwise = deps &%> act

    map obj ["even.txt","odd.txt"] &?%> \[evens,odds] -> do
        src <- readFileLines $ obj "numbers.txt"
        let (es,os) = partition even $ map read src
        writeFileLines evens $ map show es
        writeFileLines odds  $ map show os

    map obj ["dir1/out.txt","dir2/out.txt"] &?%> \[a,b] -> do
        writeFile' a "a"
        writeFile' b "b"

    (\x -> let dir = takeDirectory x in
           if takeFileName dir /= "pred" then Nothing else Just [dir </> "a.txt",dir </> "b.txt"]) &?> \outs ->
        mapM_ (`writeFile'` "") outs


test build = do
    let obj = id
    forM_ [[],["--usepredicate"]] $ \args -> do
        let nums = unlines . map show
        writeFile (obj "numbers.txt") $ nums [1,2,4,5,2,3,1]
        build ("--sleep":args)
        assertContents (obj "even.txt") $ nums [2,4,2]
        assertContents (obj "odd.txt" ) $ nums [1,5,3,1]
        build ["clean"]
        build ["--no-build","--report=-"]
        build ["dir1/out.txt"]

    build ["pred/a.txt"]
