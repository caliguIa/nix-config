{
    flake.modules.nixos.gui = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            imv
            zathura
            ffmpeg
            mpv
        ];
    };
}
