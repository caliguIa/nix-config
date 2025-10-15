let
    theme = "kanso";
    themeConfig = import ./${theme}.nix {};
in {
    inherit theme;
    inherit (themeConfig) colors variant nvimColorscheme starship tmux fzf;
}
