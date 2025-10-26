{
    flake.modules.homeManager.core = {
        pkgs,
        config,
        ...
    }: let
        customPlugins = {
            indentmini = pkgs.vimUtils.buildVimPlugin {
                name = "indentmini.nvim";
                src = pkgs.fetchFromGitHub {
                    owner = "nvimdev";
                    repo = "indentmini.nvim";
                    rev = "main";
                    hash = "sha256-YDO48kLOkzbJ9HDiQ0rQ/bbvyD8FQ9iNfSl1V0naUAs=";
                };
            };
            zendiagram = pkgs.vimUtils.buildVimPlugin {
                name = "zendiagram.nvim";
                src = pkgs.fetchFromGitHub {
                    owner = "caliguIa";
                    repo = "zendiagram.nvim";
                    rev = "main";
                    hash = "sha256-vJMoeMUAKliPy9MF6oUd+gSQ1cNXPCEcju8OXEMvYew=";
                };
            };
            timber = pkgs.vimUtils.buildVimPlugin {
                name = "timber.nvim";
                src = pkgs.fetchFromGitHub {
                    owner = "Goose97";
                    repo = "timber.nvim";
                    rev = "main";
                    hash = "";
                };
            };
            # zendiagram_local = pkgs.vimUtils.buildVimPlugin {
            #     name = "zendiagram.nvim";
            #     src =
            #         config.lib.file.mkOutOfStoreSymlink
            #         "${config.home.homeDirectory}/dev/nvim-plugins/zendiagram.nvim";
            # };
            # timber_local = pkgs.vimUtils.buildVimPlugin {
            #     name = "timber.nvim";
            #     src =
            #         config.lib.file.mkOutOfStoreSymlink
            #         "${config.home.homeDirectory}/dev/nvim-plugins/timber.nvim";
            # };
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
