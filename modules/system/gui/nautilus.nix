{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            environment.systemPackages = with pkgs; [
                nautilus
                nautilus-python
                ffmpegthumbnailer
            ];
            environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
            services.gvfs.enable = true;
            services.gnome.sushi.enable = true;
        };
}
