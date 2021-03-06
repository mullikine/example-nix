let

    base = {

        # git describe: 18.09-beta-4191-g8070a6333f3
        nixpkgsRev = "8070a6333f3fc41ef93c2b0e07f999459615cc8d";
        nixpkgsSha256 = "0v6nycl7lzr1kdsy151j10ywhxvlb4dg82h55hpjs1dxjamms9i3";

        nixpkgsArgs.config = {
            allowUnfree = true;
            cudaSupport = true;
        };

        bootPkgsPath = <nixpkgs>;
        bootPkgs = null;
        basePkgsPath = null;
        overlay = self: super: {};
        extraOverlay = self: super: {};
        srcFilter = lib: lib.nix.sources.ignoreDevCommon;
        extraSrcFilter = lib: p: t: true;
        srcTransform = lib: s: s;
        haskellArgs = {};
        pythonArgs = {};

    };

    haskell = {
        ghcVersion = "ghc843";
        overrides = pkgs: self: super: {};
        extraOverrides = pkgs: self: super: {};
        srcFilter = lib: lib.nix.sources.ignoreDevHaskell;
        extraSrcFilter = lib: p: t: true;
        srcTransform = lib: s: s;
        pkgChanges = lib: {};
        changePkgs = {};
        envMoreTools = nixpkgs: [
            (nixpkgs.callPackage (import haskell/tools/nix-tags-haskell) {})
            (nixpkgs.callPackage (import haskell/tools/cabal-new-watch) {})
            nixpkgs.haskell.packages.ghc843.apply-refact
            nixpkgs.haskell.packages.ghc843.cabal2nix
            nixpkgs.haskell.packages.ghc843.cabal-install
            nixpkgs.haskell.packages.ghc843.ghcid
            nixpkgs.haskell.packages.ghc843.hlint
            nixpkgs.haskell.packages.ghc843.hoogle
            nixpkgs.haskell.packages.ghc843.stylish-haskell
        ];
    };

    python = {
        pyVersion = "36";
        overrides = pkgs: self: super: {};
        extraOverrides = pkgs: self: super: {};
        srcFilter = lib: lib.nix.sources.ignoreDevPython;
        extraSrcFilter = lib: p: t: true;
        srcTransform = lib: s: s;
        envMoreTools = nixpkgs: [
            nixpkgs.autoflake
            nixpkgs.python3Packages.flake8
            nixpkgs.python3Packages.ipython
            nixpkgs.python3Packages.pylint
            nixpkgs.python3Packages.yapf
        ];
        envPersists = true;
    };

in

rec {

    plain = { inherit base haskell python; };

    curated = {
        base    = plain.base    // { overlay   = import top/overrides;    };
        haskell = plain.haskell // { overrides = import haskell/overrides; };
        python  = plain.python  // { overrides = import python/overrides;  };
    };

}
