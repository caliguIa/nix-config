{
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            spotify
            slack
            jetbrains.phpstorm
            jetbrains.datagrip
            qbittorrent
            sentry-cli
            ente-desktop
            ente-cli
            beekeeper-studio
        ];
    };
}
