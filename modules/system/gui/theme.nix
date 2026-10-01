let
    cursorTheme = "Adwaita";
    cursorSize = 24;
    iconTheme = "Adwaita";
    gtkTheme = "Adwaita-dark";
in
{
    flake.modules.nixos.gui =
        { lib, pkgs, ... }:
        {
            environment.systemPackages = with pkgs; [
                adwaita-icon-theme # icons and cursors
                gnome-themes-extra # Adwaita-dark for GTK3
            ];

            fonts.packages = with pkgs; [
                noto-fonts
                noto-fonts-color-emoji
            ];
            fonts.fontconfig.defaultFonts = {
                sansSerif = [ "Noto Sans" ];
                serif = [ "Noto Serif" ];
                monospace = [
                    "Berkeley Mono"
                    "Noto Sans Mono"
                ];
                emoji = [ "Noto Color Emoji" ];
            };

            # Defaults only: values already in the user's dconf db (e.g. left by
            # Plasma, or set from an app) win until reset.
            programs.dconf.profiles.user.databases = [
                {
                    settings."org/gnome/desktop/interface" = {
                        color-scheme = "prefer-dark";
                        gtk-theme = gtkTheme;
                        icon-theme = iconTheme;
                        cursor-theme = cursorTheme;
                        cursor-size = lib.gvariant.mkInt32 cursorSize;
                        font-name = "Noto Sans 10";
                        document-font-name = "Noto Sans 10";
                        monospace-font-name = "Berkeley Mono 10";
                        enable-animations = false;
                    };
                }
            ];

            # Apps that ignore the settings above (Xwayland, Qt, the greeter).
            xdg.icons.fallbackCursorThemes = [ cursorTheme ];
            environment.sessionVariables = {
                XCURSOR_THEME = cursorTheme;
                XCURSOR_SIZE = toString cursorSize;
            };

            qt = {
                enable = true;
                platformTheme = "gnome";
                style = "adwaita-dark";
            };
        };

    flake.modules.hjem.gui =
        { lib, ... }:
        let
            # GTK only reads these where GSettings isn't available, i.e. X11.
            settingsIni = lib.generators.toINI { } {
                Settings = {
                    gtk-application-prefer-dark-theme = true;
                    gtk-theme-name = gtkTheme;
                    gtk-icon-theme-name = iconTheme;
                    gtk-cursor-theme-name = cursorTheme;
                    gtk-cursor-theme-size = cursorSize;
                    gtk-enable-animations = false;
                };
            };
        in
        {
            xdg.config.files = {
                "gtk-3.0/settings.ini".text = settingsIni;
                "gtk-4.0/settings.ini".text = settingsIni;
                "sway/config.d/theme.conf".text = ''
                    seat * xcursor_theme ${cursorTheme} ${toString cursorSize}
                '';
            };
        };
}
