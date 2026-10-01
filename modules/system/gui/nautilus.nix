{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            environment.systemPackages = with pkgs; [
                nautilus
                # Loads ghostty's bundled "Open in Ghostty" extension.
                nautilus-python
                # Video thumbnails; images are covered by gdk-pixbuf.
                ffmpegthumbnailer
            ];
            environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";

            # Trash, MTP phones, SMB/SFTP locations and mounting from the sidebar.
            services.gvfs.enable = true;
            # Spacebar quick preview.
            services.gnome.sushi.enable = true;
        };
}
