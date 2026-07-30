{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            imv
            zathura
            ffmpeg
            mpv
        ];
    };
}
