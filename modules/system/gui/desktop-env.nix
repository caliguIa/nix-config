{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.kdeconnect.enable = true;
            environment.sessionVariables.NIXOS_OZONE_WL = "1";
            environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
            # All of share/ (portals, applications, thumbnailers, nautilus-python
            # extensions, gsettings schemas, ...), as Plasma used to link.
            environment.pathsToLink = [ "/share" ];

            # Desktop plumbing a full DE would otherwise bring along.
            services.udisks2.enable = true;
            services.upower.enable = true;
            services.fwupd.enable = true;
            programs.fuse.enable = true;
            xdg.icons.enable = true;
            # SVG icons for GTK apps started outside sway's wrapper (DMS, systemd).
            programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
        };
}
