{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        services.gnome.evolution-data-server.enable = true;
        services.gnome.gnome-online-accounts.enable = true;
        services.dbus.enable = true;
        services.dbus.packages = with pkgs; [gnome-calendar];
        programs.dconf.enable = true;
        environment.systemPackages = with pkgs; [
            gnome-calendar
            gnome-online-accounts
            gnome-online-accounts-gtk
            evolution-data-server-gtk4
            evolution-data-server
            evolution
        ];
    };
}
