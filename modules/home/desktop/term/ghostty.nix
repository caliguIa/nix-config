{
    flake.modules.homeManager.desktop = {style, ...}: {
        programs.ghostty = {
            enable = true;
            systemd.enable = true;
            enableFishIntegration = true;
            installBatSyntax = true;
            installVimSyntax = true;
            settings = {
                font-family = style.font.monospace.name;
                font-size = style.font.monospace.size;
                background = style.colors.background;
                foreground = style.colors.foreground;
                palette = [
                    "0=${style.colors.base00}"
                    "1=${style.colors.base08}"
                    "2=${style.colors.base0B}"
                    "3=${style.colors.base0A}"
                    "4=${style.colors.base0D}"
                    "5=${style.colors.base0E}"
                    "6=${style.colors.base0C}"
                    "7=${style.colors.base05}"
                    "8=${style.colors.base03}"
                    "9=${style.colors.base08}"
                    "10=${style.colors.base0B}"
                    "11=${style.colors.base0A}"
                    "12=${style.colors.base0D}"
                    "13=${style.colors.base0E}"
                    "14=${style.colors.base0C}"
                    "15=${style.colors.base07}"
                ];
            };
        };
    };
}
