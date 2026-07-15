{inputs, ...}: {
    flake.modules.homeManager.core = {pkgs, ...}: {
        programs.neovim = {
            enable = true;
            package = inputs.nvim-nightly.packages.${pkgs.stdenvNoCC.system}.neovim;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = true;
            withPython3 = false;
            withRuby = false;
        };
    };
}
