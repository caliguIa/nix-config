{
    flake.modules.nixos.gui = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            ffmpeg
            imv
            mpv
            poppler
            resvg
            spotify
            zathura
        ];
    };
}
