{
    flake.modules.nixos.gui = { pkgs, ... }: {
        services.dbus.enable = true;
        programs.dconf.enable = true;
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [ ];
        };
        environment.systemPackages = with pkgs; [
            bitwarden-desktop
            bruno
            claude-code
            glib.bin
            slack
            tableplus
        ];
    };
}
