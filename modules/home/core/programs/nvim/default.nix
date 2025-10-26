{inputs, ...}: {
    flake.modules.homeManager.core = {pkgs, ...}: {
        programs.neovim = {
            enable = true;
            package = inputs.nvim-nightly.packages.${pkgs.system}.neovim;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = false;
            withPython3 = false;
            withRuby = false;
        };
    };
}
