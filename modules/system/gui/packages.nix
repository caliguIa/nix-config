{
    flake.modules.nixos.gui = { pkgs, ... }: {
        programs.nix-ld = {
            enable = true;
            libraries = with pkgs; [ ];
        };
        environment.systemPackages = with pkgs; [
            bruno
            claude-code
            herdr
            glib.bin
            (callPackage ./_keyguard.nix { })
            skills
            slack
            tableplus
        ];
    };
}
