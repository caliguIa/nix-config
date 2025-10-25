{inputs, ...}: {
    flake.modules.homeManager.core = {config, ...}: {
        config = {
            nixCats = {
                enable = true;
                nixpkgs_version = inputs.nixpkgs;
                luaPath = inputs.self + /modules/home/core/programs/nvim;
                addOverlays = [(inputs.nixCats.utils.standardPluginOverlay inputs)];
                packageNames = ["nvim"];
                categoryDefinitions.replace = {pkgs, ...}: {
                    lspsAndRuntimeDeps = {
                        general = with pkgs; [
                            emmylua-ls
                            marksman
                            nixd
                            taplo
                            just-lsp
                            vscode-langservers-extracted
                            nodePackages.bash-language-server
                            alejandra
                            lua-language-server
                            sleek
                            stylua
                            sqruff
                        ];
                    };
                    startupPlugins = {
                        general = with pkgs.vimPlugins; [
                            kanso-nvim
                            plenary-nvim
                            oil-nvim
                            mini-nvim
                            nvim-lspconfig
                            conform-nvim
                            git-conflict-nvim
                            vim-test
                            vim-tmux-navigator
                            nvim-bqf
                            neogit
                            fff-nvim
                            codecompanion-nvim
                            nvim-treesitter
                            nvim-treesitter.withAllGrammars
                            nvim-treesitter-textobjects
                            ts-comments-nvim
                            nvim-ts-autotag
                            aerial-nvim
                            pkgs.neovimPlugins.indentmini
                            pkgs.neovimPlugins.zendiagram
                            # pkgs.neovimPlugins.timber
                        ];
                    };
                    optionalPlugins = {};
                    python3.libraries = {};
                    extraWrapperArgs = {};
                    sharedLibraries = {};
                    environmentVariables = {};
                };
                packageDefinitions.replace = {
                    nvim = {pkgs, ...}: {
                        settings = {
                            wrapRc = false;
                            unwrappedCfgPath = "${config.home.homeDirectory}/nix-config/modules/home/core/programs/nvim";
                            aliases = ["vi" "vim" "bim"];
                            hosts.node.enable = true;
                            hosts.ruby.enable = true;
                            neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
                        };
                        categories = {general = true;};
                        extra = {
                            colourscheme = "kanso";
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
                                        if pkgs.stdenvNoCC.isDarwin
                                        then nixDarwinOptions
                                        else nixosOptions
                                    }.home-manager.users.type.getSubOptions []'';
                                flake_part_options = "${flakePath}.debug.options";
                                flake_part_options2 = "${flakePath}.currentSystem.options";
                            };
                        };
                    };
                };
            };
        };
    };
}
