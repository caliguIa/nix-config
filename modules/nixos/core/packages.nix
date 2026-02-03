{self, ...}: {
    flake.modules.darwin.core = {pkgs, ...}: {
        imports = [self.modules.generic.system-core-packages];
        programs = {
            _1password-gui.enable = true;
        };
        environment.systemPackages = with pkgs; [
            prr
            hurl
            iina
            broot
            pika
            wiki-tui
        ];
    };

    flake.modules.nixos.core = {
        imports = [self.modules.generic.system-core-packages];
    };

    flake.modules.generic.system-core-packages = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            bottom
            curl
            eza
            fd
            fish
            gitu
            gnupg
            gh
            htop
            jq
            lazydocker
            just
            nix-output-monitor
            ouch
            ripgrep
            tree
            uutils-coreutils-noprefix
            wget
        ];
    };
}
