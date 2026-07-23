{
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            spotify
            slack
            beekeeper-studio
            bruno
            tuicr
            strawberry
            tableplus
        ];
    };
}
