{
    flake.modules.hjem.desktop = {
        pkgs,
        lib,
        ...
    }: let
        settingsIni = {
            generator = lib.generators.toINI {};
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
            # GTK2_RC_FILES was previously set via home.sessionVariables. fish
            # auto-sources conf.d/*.fish, keeping this desktop-scoped.
            "fish/conf.d/gtk.fish".text = ''
                set -gx GTK2_RC_FILES $HOME/.gtkrc-2.0
            '';
        };
    };
}
