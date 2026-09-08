{
    flake.modules.nixos.host_karla = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            framework-tool
        ];
    };
}
