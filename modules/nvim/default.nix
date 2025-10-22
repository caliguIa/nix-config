{
    inputs,
    nvimPath,
    username,
    helpers,
    ...
}: let
    inherit (inputs) nixpkgs;
    inherit (inputs.nixCats) utils;
    luaPath = nvimPath;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    mkHomeDirectory = system: helpers.mkHomeDirectory username system;
    isDarwin = system: helpers.isDarwin system;
    themeConfig = import (builtins.dirOf nvimPath + "/themes");
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
        lspsAndRuntimeDeps = {
            general = [
                pkgs.emmylua-ls
                pkgs.marksman
                pkgs.nixd
                pkgs.taplo
                pkgs.just-lsp
                pkgs.vscode-langservers-extracted
                pkgs.nodePackages.bash-language-server
                pkgs.alejandra
                pkgs.lua-language-server
                pkgs.sleek
                pkgs.stylua
                pkgs.sqruff
            ];
        };
        startupPlugins = {
            theme = [
                pkgs.vimPlugins.kanso-nvim
            ];
            general = [
                pkgs.vimPlugins.plenary-nvim
                pkgs.vimPlugins.oil-nvim
                pkgs.vimPlugins.mini-nvim
                pkgs.vimPlugins.nvim-lspconfig
                pkgs.vimPlugins.conform-nvim
                pkgs.vimPlugins.git-conflict-nvim
                pkgs.vimPlugins.vim-test
                pkgs.vimPlugins.vim-tmux-navigator
                pkgs.vimPlugins.nvim-bqf
                pkgs.vimPlugins.neogit
                pkgs.vimPlugins.fff-nvim
                pkgs.vimPlugins.codecompanion-nvim
                pkgs.vimPlugins.nvim-treesitter
                pkgs.vimPlugins.nvim-treesitter.withAllGrammars
                pkgs.vimPlugins.nvim-treesitter-textobjects
                pkgs.vimPlugins.ts-comments-nvim
                pkgs.vimPlugins.nvim-ts-autotag
                pkgs.neovimPlugins.indentmini
                pkgs.neovimPlugins.zendiagram
                pkgs.neovimPlugins.ts-error
                pkgs.vimPlugins.aerial-nvim
                # pkgs.neovimPlugins.timber
            ];
        };
        optionalPlugins = {};
        sharedLibraries = {};
        extraWrapperArgs = {};
        python3.libraries = {};
        extraLuaPackages = {};
    };

    packageDefinitions = {
        nvim = {pkgs, ...}: {
            settings = {
                wrapRc = false;
                unwrappedCfgPath = "${mkHomeDirectory pkgs.system}/nix-config/modules/nvim";
                aliases = ["vi" "vim" "bim"];
                hosts.node.enable = true;
                hosts.ruby.enable = true;
                neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            categories = {
                general = true;
                theme = true;
            };
            extra = {
                colorscheme = themeConfig.nvimColorscheme;
                nixdExtras = let
                    flakePath = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}")'';
                    nixosOptions = "${flakePath}.nixosConfigurations.george.options";
                    nixDarwinOptions = "${flakePath}.darwinConfigurations.polyakov.options";
                in {
                    nixpkgs = "import ${flakePath}.inputs.nixpkgs {}";
                    flake = "${flakePath}.outputs";
                    nixos_options = nixosOptions;
                    nix_darwin_options = nixDarwinOptions;
                    home_manager_options = ''${
                            if isDarwin pkgs.system
                            then nixDarwinOptions
                            else nixosOptions
                        }.home-manager.users.type.getSubOptions []'';
                };
            };
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
