{
    flake.modules.homeManager.desktop = {
        programs.ghostty = {
            enable = true;
            systemd.enable = true;
            enableBashIntegration = true;
            installBatSyntax = true;
            installVimSyntax = true;
            settings = {
                theme = "kanso-zen";
                maximize = true;
                selection-clear-on-copy = true;
                copy-on-select = true;
                font-family = "Berkeley Mono";
                font-size = 14;
                adjust-cell-height = "25%";
                keybind = [
                    "alt+h=goto_split:left"
                    "alt+j=goto_split:down"
                    "alt+k=goto_split:up"
                    "alt+l=goto_split:right"
                ];
            };
            themes = {
                kanso-pearl = {
                    background = "#f2f1ef";
                    foreground = "#22262D";
                    selection-background = "#e2e1df";
                    selection-foreground = "#22262D";
                    cursor-color = "#22262D";
                    palette = [
                        "0=#22262D"
                        "1=#c84053"
                        "2=#6f894e"
                        "3=#77713f"
                        "4=#4d699b"
                        "5=#b35b79"
                        "6=#597b75"
                        "7=#9F9F99"
                        "8=#5C6066"
                        "9=#d7474b"
                        "10=#6e915f"
                        "11=#836f4a"
                        "12=#6693bf"
                        "13=#624c83"
                        "14=#5e857a"
                        "15=#f2f1ef"
                    ];
                };
                kanso-zen = {
                    background = "#090E13";
                    foreground = "#c5c9c7";
                    selection-background = "#22262D";
                    selection-foreground = "#c5c9c7";
                    cursor-color = "#c5c9c7";
                    palette = [
                        "0=#090E13"
                        "1=#c4746e"
                        "2=#8a9a7b"
                        "3=#c4b28a"
                        "4=#8ba4b0"
                        "5=#a292a3"
                        "6=#8ea4a2"
                        "7=#a4a7a4"
                        "8=#5C6066"
                        "9=#e46876"
                        "10=#87a987"
                        "11=#e6c384"
                        "12=#7fb4ca"
                        "13=#938aa9"
                        "14=#7aa89f"
                        "15=#c5c9c7"
                    ];
                };
            };
        };
    };
}
