{inputs, ...} @ attrs: let
    inherit (inputs) nixpkgs; # <-- nixpkgs = inputs.nixpkgsSomething;
    inherit (inputs.nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    extra_pkg_config = {
        allowUnfree = true;
    };
    dependencyOverlays =
        /*
    (import ./overlays inputs) ++
    */
        [
            # see :help nixCats.flake.outputs.overlays
            # This overlay grabs all the inputs named in the format
            # `plugins-<pluginName>`
            # Once we add this overlay to our nixpkgs, we are able to
            # use `pkgs.neovimPlugins`, which is a set of our plugins.
            (utils.standardPluginOverlay inputs)
            # add any flake overlays here.

            # when other people mess up their overlays by wrapping them with system,
            # you may instead call this function on their overlay.
            # it will check if it has the system in the set, and if so return the desired overlay
            # (utils.fixSystemizedOverlay inputs.codeium.overlays
            #   (system: inputs.codeium.overlays.${system}.default)
            # )
        ];

    categoryDefinitions = {
        pkgs,
        settings,
        categories,
        extra,
        name,
        mkPlugin,
        ...
    } @ packageDef: {
        lspsAndRuntimeDeps = with pkgs; {
            general = [
                docker-compose-language-service
                dockerfile-language-server-nodejs
                intelephense
                lua-language-server
                marksman
                nixd
                rust-analyzer
                typescript
                vscode-langservers-extracted
                nodePackages.bash-language-server
                vtsls
                alejandra
                nodePackages.prettier
                prettierd
                sleek
                stylua
                php82Packages.composer
                zig
            ];
        };

        startupPlugins = with pkgs.vimPlugins; {
            theme = builtins.getAttr (extra.colorscheme or "e-ink") {
                "e-ink" = pkgs.neovimPlugins.eink;
            };
            general = [
                plenary-nvim
                mini-nvim
                nvim-lspconfig
                conform-nvim
                fugitive
                git-conflict-nvim
                undotree
                vim-test
                vim-tmux-navigator
                pkgs.neovimPlugins.indentmini
                pkgs.neovimPlugins.timber
                pkgs.neovimPlugins.eink
                codecompanion-nvim
                nvim-dbee
                nui-nvim
                nvim-treesitter
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                ts-comments-nvim
                nvim-ts-autotag
                friendly-snippets
                luvit-meta
            ];
        };
        optionalPlugins = {};
        sharedLibraries = {};
        extraWrapperArgs = {};
        python3.libraries = {};
        extraLuaPackages = {};
        environmentVariables = {
            test = {
                CATTESTVAR = "It worked!";
            };
        };
    };

    packageDefinitions = {
        nvim = {
            pkgs,
            name,
            ...
        }: {
            settings = {
                suffix-path = true;
                suffix-LD = true;
                wrapRc = true;
                useBinaryWrapper = true;
                aliases = ["vi" "vim" "bim"];
                hosts.node.enable = true;
                hosts.python3.enable = true;
                hosts.perl.enable = false;
                hosts.ruby.enable = true;
                neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            categories = {
                general = true;
                theme = true;
                test = true;
            };
            extra = {
                colorscheme = "e-ink";
            };
        };
    };
    defaultPackageName = "nvim";
in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
        nixCatsBuilder = utils.baseBuilder luaPath {
            inherit system dependencyOverlays extra_pkg_config nixpkgs;
        }
        categoryDefinitions
        packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs {inherit system;};
    in {
        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
            default = pkgs.mkShell {
                name = defaultPackageName;
                packages = [defaultPackage];
                inputsFrom = [];
                shellHook = ''
                '';
            };
        };
    })
    // (let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
            moduleNamespace = [defaultPackageName];
            inherit
                defaultPackageName
                dependencyOverlays
                luaPath
                categoryDefinitions
                packageDefinitions
                extra_pkg_config
                nixpkgs
                ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
            moduleNamespace = [defaultPackageName];
            inherit
                defaultPackageName
                dependencyOverlays
                luaPath
                categoryDefinitions
                packageDefinitions
                extra_pkg_config
                nixpkgs
                ;
        };
    in {
        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
            # we pass in the things to make a pkgs variable to build nvim with later
            inherit nixpkgs dependencyOverlays extra_pkg_config;
            # and also our categoryDefinitions
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
    })
