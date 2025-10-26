topLevel @ {inputs, ...}: {
    flake.modules.homeManager.core = {
        pkgs,
        config,
        ...
    }: {
        xdg.configFile."nvim".source =
            config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/nix-config/modules/home/core/programs/nvim/lua";
        programs.neovim = {
            enable = true;
            package = inputs.nvim-nightly.packages.${pkgs.system}.neovim;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = false;
            withPython3 = false;
            withRuby = false;
            # extraWrapperArgs = [
            #     "--set"
            #     "NVIM_PACKPATH"
            # ];
            extraPackages = with pkgs; [
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
            plugins = with pkgs.vimPlugins;
                [
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
                ]
                ++ [
                    (pkgs.vimUtils.buildVimPlugin {
                        name = "indentmini.nvim";
                        src = pkgs.fetchFromGitHub {
                            owner = "nvimdev";
                            repo = "indentmini.nvim";
                            rev = "main";
                            hash = "sha256-YDO48kLOkzbJ9HDiQ0rQ/bbvyD8FQ9iNfSl1V0naUAs=";
                        };
                    })
                    (pkgs.vimUtils.buildVimPlugin {
                        name = "zendiagram.nvim";
                        src = pkgs.fetchFromGitHub {
                            owner = "caliguIa";
                            repo = "zendiagram.nvim";
                            rev = "main";
                            hash = "sha256-vJMoeMUAKliPy9MF6oUd+gSQ1cNXPCEcju8OXEMvYew=";
                        };
                    })
                    # (pkgs.vimUtils.buildVimPlugin {
                    #     name = "timber.nvim";
                    #     src = pkgs.fetchFromGitHub {
                    #         owner = "Goose97";
                    #         repo = "timber.nvim";
                    #         rev = "main";
                    #         hash = "";
                    #     };
                    # })
                ];
        };
    };
}
