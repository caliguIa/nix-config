{
    flake.modules.homeManager.core = {pkgs, ...}: let
        customPlugins = with pkgs; {
            indentmini = vimUtils.buildVimPlugin {
                name = "indentmini.nvim";
                src = fetchFromGitHub {
                    owner = "nvimdev";
                    repo = "indentmini.nvim";
                    rev = "main";
                    hash = "sha256-YDO48kLOkzbJ9HDiQ0rQ/bbvyD8FQ9iNfSl1V0naUAs=";
                };
            };
            timber = vimUtils.buildVimPlugin {
                name = "timber.nvim";
                src = fetchFromGitHub {
                    owner = "Goose97";
                    repo = "timber.nvim";
                    rev = "main";
                    hash = "";
                };
            };
            zendiagram = vimUtils.buildVimPlugin {
                name = "zendiagram.nvim";
                src = fetchFromGitHub {
                    owner = "caliguIa";
                    repo = "zendiagram.nvim";
                    rev = "main";
                    hash = "sha256-vJMoeMUAKliPy9MF6oUd+gSQ1cNXPCEcju8OXEMvYew=";
                };
            };
        };
        allPlugins = pkgs.vimPlugins // customPlugins;
    in {
        programs.neovim.plugins = with allPlugins; [
            aerial-nvim
            codecompanion-nvim
            conform-nvim
            fff-nvim
            git-conflict-nvim
            indentmini
            kanso-nvim
            kitty-scrollback-nvim
            mini-nvim
            neogit
            nvim-bqf
            nvim-lspconfig
            nvim-treesitter
            nvim-treesitter.withAllGrammars
            nvim-treesitter-textobjects
            nvim-ts-autotag
            oil-nvim
            plenary-nvim
            snacks-nvim
            ts-comments-nvim
            vim-test
            zendiagram
        ];
    };
}
