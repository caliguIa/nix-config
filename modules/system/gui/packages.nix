{
    flake.modules.nixos.gui = { pkgs, ... }: {
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [ ];
        };
        environment.systemPackages = with pkgs; [
            bruno
            claude-code
            glib.bin
            slack
            tableplus
        ];
    };
}
