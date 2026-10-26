{
    flake.modules.hjem.gui =
        {
            pkgs,
            lib,
            ...
        }:
        let
            inherit (lib.generators) toKeyValue mkKeyValueDefault;
            ghostty = toKeyValue {
                mkKeyValue = mkKeyValueDefault { } " = ";
                listsAsDuplicateKeys = true;
            };
        in
        {
            packages = [
                pkgs.ghostty
                pkgs.ghostty.terminfo
            ];
            xdg.config.files = {
                "ghostty/config" = {
                    generator = ghostty;
                    value = {
                        adjust-cell-height = "25%";
                        copy-on-select = true;
                        font-family = "Berkeley Mono";
                        font-size = 14;
                        keybind = [
                            "global:cmd+backquote=toggle_quick_terminal"
                            "performable:ctrl+c=copy_to_clipboard"
                            "ctrl+shift+v=paste_from_clipboard"
                            "super+v=paste_from_clipboard"
                            "ctrl+space>c=new_tab"
                            "ctrl+space>n=next_tab"
                            "ctrl+space>p=previous_tab"
                            "ctrl+space>v=new_split:right"
                            "ctrl+space>h=new_split:down"
                            "ctrl+space>equal=equalize_splits"
                            "ctrl+space>q=close_surface"
                            "ctrl+alt+h=goto_split:left"
                            "ctrl+alt+j=goto_split:down"
                            "ctrl+alt+k=goto_split:up"
                            "ctrl+alt+l=goto_split:right"
                            "ctrl+enter=unbind"
                        ];
                        maximize = true;
                        selection-clear-on-copy = true;
                        split-inherit-working-directory = true;
                        theme = "Noir";
                        window-decoration = "none";
                    };
                };
                # mirrors modules/system/core/nvim/lua/colors/noir.lua
                "ghostty/themes/Noir" = {
                    generator = ghostty;
                    value = {
                        palette = [
                            "0=#1c1c1c" # noir_10
                            "1=#c4746e" # red
                            "2=#76946a" # green
                            "3=#dca561" # yellow_git
                            "4=#658594" # blue
                            "5=#e46876" # red_bright (no magenta in the palette)
                            "6=#9edaed" # blue_bright
                            "7=#a4a7a4" # noir_2
                            "8=#585858" # noir_7
                            "9=#e46876" # red_bright
                            "10=#98bb6c" # green_bright
                            "11=#e6c384" # yellow_bright
                            "12=#9edaed" # blue_bright
                            "13=#e46876" # red_bright
                            "14=#9edaed" # blue_bright
                            "15=#eeeeee" # noir_0
                        ];
                        background = "#121212";
                        foreground = "#a4a7a4";
                        cursor-color = "#9edaed";
                        cursor-text = "#121212";
                        selection-background = "#303030";
                        selection-foreground = "#eeeeee";
                    };
                };
            };
        };
}
