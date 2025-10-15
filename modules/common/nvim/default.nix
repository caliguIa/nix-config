{inputs, ...}: let
    inherit (inputs) nixpkgs;
    inherit (inputs.nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    themeConfig = import ../themes;
    extra_pkg_config.allowUnfree = true;
    fffPluginOverlay = final: prev: {
        vimPlugins =
            prev.vimPlugins
            // {
                fff-nvim = inputs.plugins-fff.packages.${final.system}.fff-nvim;
            };
    };
    dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
        fffPluginOverlay
    ];
    categoryDefinitions = {pkgs, ...}: {
        lspsAndRuntimeDeps = with pkgs; {
            general = [
                emmylua-ls
                marksman
                nixd
                taplo
                just-lsp
                vscode-langservers-extracted
                nodePackages.bash-language-server
                alejandra
                sleek
                stylua
                sqruff
            ];
        };
        startupPlugins = with pkgs.vimPlugins; {
            theme = [
                kanso-nvim
                github-nvim-theme
            ];
            general = [
                plenary-nvim
                oil-nvim
                mini-nvim
                nvim-lspconfig
                conform-nvim
                git-conflict-nvim
                undotree
                vim-test
                vim-tmux-navigator
                nvim-bqf
                pkgs.neovimPlugins.indentmini
                pkgs.neovimPlugins.zendiagram
                pkgs.neovimPlugins.ts-error
                pkgs.neovimPlugins.fold-imports
                # pkgs.neovimPlugins.timber
                neogit
                fff-nvim
                codecompanion-nvim
                nvim-treesitter
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                ts-comments-nvim
                nvim-ts-autotag
            ];
        };
        optionalPlugins = {};
        sharedLibraries = {};
        extraWrapperArgs = {};
        python3.libraries = {};
        extraLuaPackages = {};
        environmentVariables = {};
    };

    packageDefinitions = {
        nvim = {pkgs, ...}: {
            settings = {
                suffix-path = true;
                suffix-LD = true;
                wrapRc = true;
                useBinaryWrapper = true;
                aliases = ["vi" "vim" "bim"];
                hosts.node.enable = true;
                hosts.python3.enable = false;
                hosts.perl.enable = false;
                hosts.ruby.enable = true;
                neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            categories = {
                general = true;
                theme = true;
            };
            extra.colorscheme = themeConfig.nvimColorscheme;
        };
    };
    defaultPackageName = "nvim";
in
    forEachSystem (system: let
        nixCatsBuilder = utils.baseBuilder luaPath {
            inherit system dependencyOverlays extra_pkg_config nixpkgs;
        }
        categoryDefinitions
        packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs {inherit system;};
    in {
        packages = utils.mkAllWithDefault defaultPackage;
        devShells = {
            default = pkgs.mkShell {
                name = defaultPackageName;
                packages = [defaultPackage];
                inputsFrom = [];
                shellHook = "";
            };
        };
    })
    // (let
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
        overlays = utils.makeOverlays luaPath {
            inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;
        nixosModules.default = nixosModule;
        homeModules.default = homeModule;
        inherit utils nixosModule homeModule;
        inherit (utils) templates;
    })
