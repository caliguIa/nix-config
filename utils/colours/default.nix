let
    theme = "kanso";
    themeConfig = import ./${theme}.nix {};
in {
    inherit theme;
    inherit (themeConfig) colours variant nvimColourscheme starship tmux fzf;
}
