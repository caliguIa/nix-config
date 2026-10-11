{
    flake.modules.nixos.gui = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            ffmpeg
            gelly
            imv
            mpv
            poppler
            resvg
            spotify
            zathura
        ];
    };
}
