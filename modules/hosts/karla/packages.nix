{
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            spotify
            slack
            google-chrome
            unzip
        ];
    };
}
