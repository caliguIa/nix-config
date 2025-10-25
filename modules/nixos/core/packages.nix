{self, ...}: {
    flake.modules.darwin.core = {pkgs, ...}: {
        imports = [self.modules.generic.system-core-packages];
        programs = {
            _1password-gui.enable = true;
        };
        environment.systemPackages = with pkgs; [
            gh-dash
            prr
            _1password-cli
            hurl
            iina
            broot
            jira-cli-go
            lazydocker
            pika
            raycast
            wiki-tui
        ];
    };

    flake.modules.nixos.core = {
        imports = [self.modules.generic.system-core-packages];
    };

    flake.modules.generic.system-core-packages = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            bat
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
            just
            nix-output-monitor
            ripgrep
            tree
            yazi
            wget
        ];
    };
}
