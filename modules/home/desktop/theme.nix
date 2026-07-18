{
    flake.modules.hjem.desktop = {
        pkgs,
        lib,
        ...
    }: let
        inherit (lib.generators) toINI;
        settingsIni = {
            generator = toINI {};
            value.Settings.gtk-icon-theme-name = "Adwaita";
        };
    in {
        packages = [pkgs.adwaita-icon-theme];

        files.".gtkrc-2.0".text = ''
            gtk-icon-theme-name = "Adwaita"
        '';

        xdg.config.files = {
            "gtk-3.0/settings.ini" = settingsIni;
            "gtk-4.0/settings.ini" = settingsIni;
            "fish/conf.d/gtk.fish".text = ''
                set -gx GTK2_RC_FILES $HOME/.gtkrc-2.0
            '';
        };
    };
}
