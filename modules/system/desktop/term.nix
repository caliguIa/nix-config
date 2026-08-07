{
    flake.modules.hjem.desktop =
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
            packages = [ pkgs.ghostty ];

            xdg.config.files = {
                "ghostty/config" = {
                    generator = ghostty;
                    value = {
                        adjust-cell-height = "25%";
                        copy-on-select = true;
                        font-family = "Berkeley Mono";
                        font-size = 14;
                        keybind = [
                            "performable:ctrl+c=copy_to_clipboard"
                            "ctrl+v=paste_from_clipboard"
                            "ctrl+space>c=new_tab"
                            "ctrl+space>n=next_tab"
                            "ctrl+space>p=previous_tab"
                            "ctrl+space>v=new_split:right"
                            "ctrl+space>h=new_split:down"
                            "ctrl+space>equal=equalize_splits"
                            "ctrl+space>q=close_surface"
                            "alt+h=goto_split:left"
                            "alt+j=goto_split:down"
                            "alt+k=goto_split:up"
                            "alt+l=goto_split:right"
                            "ctrl+enter=unbind"
                        ];
                        maximize = true;
                        selection-clear-on-copy = true;
                        split-inherit-working-directory = true;
                        theme = "luna";
                        window-decoration = "none";
                    };
                };
                "ghostty/themes/luna".text = ''
                    # name = "luna"
                    # author = "wtfox"

                    palette = 0=#000000
                    palette = 1=#e08585
                    palette = 2=#6fbe80
                    palette = 3=#c2916a
                    palette = 4=#75a1c7
                    palette = 5=#c4a8d6
                    palette = 6=#75a1c7
                    palette = 7=#c7c7c7
                    palette = 8=#888888
                    palette = 9=#e08585
                    palette = 10=#6fbe80
                    palette = 11=#d9a35a
                    palette = 12=#8c9cb8
                    palette = 13=#c4a8d6
                    palette = 14=#75a1c7
                    palette = 15=#ffffff
                    palette = 16=#a8a8a8
                    palette = 17=#c2916a
                    palette = 18=#1c1c1c
                    palette = 19=#404040
                    palette = 20=#888888
                    palette = 21=#c7c7c7

                    background = #060606
                    foreground = #e4e4e8
                    cursor-color = #e4e4e8
                    selection-background = #404040
                    selection-foreground = #e4e4e8
                '';
            };
        };
}
