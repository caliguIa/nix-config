{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            programs.kdeconnect.enable = true;
            environment.sessionVariables.NIXOS_OZONE_WL = "1";
            environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
            environment.pathsToLink = [ "/share" ];
            services.udisks2.enable = true;
            services.upower.enable = true;
            services.fwupd.enable = true;
            programs.fuse.enable = true;
            xdg.icons.enable = true;
            programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
        };
}
