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
            zendiagram = vimUtils.buildVimPlugin {
                name = "zendiagram.nvim";
                src = fetchFromGitHub {
                    owner = "caliguIa";
                    repo = "zendiagram.nvim";
                    rev = "main";
                    hash = "sha256-vJMoeMUAKliPy9MF6oUd+gSQ1cNXPCEcju8OXEMvYew=";
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
        };
        allPlugins = pkgs.vimPlugins // customPlugins;
    in {
        programs.neovim.plugins = with allPlugins; [
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
            indentmini
            zendiagram
        ];
    };
}
