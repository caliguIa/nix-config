{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            pwvucontrol
            playerctl
            grim
            slurp
            imv
            zathura
            wl-screenrec
            ffmpeg
            mpv
            libva-utils
        ];
        hardware.graphics.extraPackages = with pkgs; [
            libva-vdpau-driver
            libva
            mesa
        ];
    };
}
