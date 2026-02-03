{
    flake.modules.homeManager.core = {pkgs, ...}: let
        customPlugins = with pkgs; {
            indentmini = vimUtils.buildVimPlugin {
                name = "indentmini.nvim";
                src = fetchFromGitHub {
                    owner = "nvimdev";
                    repo = "indentmini.nvim";
                    rev = "main";
                    hash = "sha256-J3D+nbalJqZ4aeFBD7veW6TuI0BEU2jbx5pMEew4dkA=";
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
            ts-textobjects = vimUtils.buildVimPlugin {
                name = "nvim-treesitter-textobjects";
                src = fetchFromGitHub {
                    owner = "nvim-treesitter";
                    repo = "nvim-treesitter-textobjects";
                    rev = "main";
                    hash = "sha256-J3D+nbalJqZ4aeFBD7veW6TuI0BEU2jbx5pMEew4dkA=";
                };
            };
        };
    in {
        programs.neovim.plugins = with pkgs.vimPlugins // customPlugins; [
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
            ts-textobjects
            # switch back once nixpkgs uses main
            # nvim-treesitter-textobjects
            nvim-ts-autotag
            oil-nvim
            plenary-nvim
            ts-comments-nvim
            vim-test
            zendiagram
        ];
    };
}
