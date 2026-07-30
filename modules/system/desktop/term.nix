{
    flake.modules.hjem.desktop = {
        pkgs,
        lib,
        ...
    }: let
        inherit (lib.generators) toKeyValue mkKeyValueDefault;
        ghostty = toKeyValue {
            mkKeyValue = mkKeyValueDefault {} " = ";
            listsAsDuplicateKeys = true;
        };
    in {
        packages = [pkgs.ghostty];

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
                    theme = "Kanso Mist";
                    window-decoration = "none";
                };
            };
        };
    };
}
