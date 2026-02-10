{inputs, ...}: {
    flake.modules.homeManager.core = {pkgs, ...}: {
        stylix.targets.neovim.enable = false;
        programs.neovim = {
            enable = true;
            package = inputs.nvim-nightly.packages.${pkgs.stdenv.system}.neovim;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = true;
            withPython3 = false;
            withRuby = false;
        };
        home.packages = with pkgs; [
            tree-sitter
            gcc
        ];
    };
}
