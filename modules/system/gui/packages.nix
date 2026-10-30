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
            keyguard
            laravel-artisan
            skills
            slack
            tableplus
        ];
    };
}
