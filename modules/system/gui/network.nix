{
    flake.modules.nixos.gui = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            mullvad
            mullvad-vpn
        ];
        services.mullvad-vpn.enable = true;
        programs.localsend.enable = true;
    };
}
