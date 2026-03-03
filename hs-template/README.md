# hs-template

A Haskell project template generator.

## Install to ~/.local/bin/

```sh
cabal install --installdir=$HOME/.local/bin/ --overwrite-policy=always
```

Make sure `$HOME/.local/bin/` is in your PATH.

## Build

```sh
cabal build
```

## Generate a new project

```sh
cabal run hs-template myproject
```

This will create a directory named `myproject` with:
- `myproject.cabal` - Cabal package file
- `myproject.hs` - Main Haskell source file with example code
- `README.md` - Project README
- `hie.yaml` - Haskell IDE Engine configuration
