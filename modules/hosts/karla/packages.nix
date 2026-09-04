{
    flake.modules.nixos.host_karla = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            bruno
            framework-tool
            poppler
            resvg
            slack
            spotify
            tableplus
        ];
    };
}
