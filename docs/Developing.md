# Developing Shake

I welcome contributions. Generally:

* Don't spend too much time working on something before raising an issue for it. There might be suggestions I can give, or reasons the work might not be appropriate.
* Pull requests are the best way to submit stuff.

### Development Workflow

I generally load Shake up in `ghci`, starting from the root directory, which has a `.ghci` file to set things up. Develop, hit `:r` to reload, then `:test` to run the test suite.

### Sandboxes

The tests do things like recompilation, which isn't particularly Cabal sandbox friendly. You can run some tests by doing:

    $ cabal repl shake-test
    $ :main config test --no-report