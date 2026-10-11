{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            environment.sessionVariables.NIXOS_OZONE_WL = "1";
            environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";
            environment.pathsToLink = [ "/share" ];
            services.udisks2.enable = true;
            services.upower.enable = true;
            services.fwupd.enable = true;
            programs.fuse.enable = true;
            programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
            # Both default to on via services.graphical-desktop (pulled in by sway):
            # speech-dispatcher drags in ~650MiB of mbrola voices, and the default
            # font set adds Noto CJK, unifont, freefont etc. on top of theme.nix.
            services.speechd.enable = false;
            fonts.enableDefaultPackages = false;
        };
}
