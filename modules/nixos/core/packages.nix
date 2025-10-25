{
    flake.modules.darwin.core = {pkgs, ...}: {
        programs = {
            _1password-gui.enable = true;
        };
        environment.systemPackages = with pkgs; [
            # inputs.self.packages.${pkgs.system}.nvim
            bat
            bottom
            curl
            eza
            fd
            fish
            gitu
            gnupg
            gh
            gh-dash
            htop
            jq
            just
            nix-output-monitor
            prr
            ripgrep
            tree
            yazi
            wget

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

    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            # inputs.self.packages.${pkgs.system}.nvim
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
