{
    flake.modules.nixos.host_karla = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            bruno
            poppler
            resvg
            slack
            spotify
            # tableplus
        ];
    };
}
