{
    flake.modules.nixos.packages = {
        inputs,
        pkgs,
        ...
    }: {
        environment.systemPackages = [
            inputs.self.packages.${pkgs.system}.nvim
            pkgs.bat
            pkgs.bottom
            pkgs.curl
            pkgs.eza
            pkgs.fd
            pkgs.fish
            pkgs.gitu
            pkgs.gnupg
            pkgs.gh
            pkgs.gh-dash
            pkgs.htop
            pkgs.jq
            pkgs.just
            pkgs.nix-output-monitor
            pkgs.prr
            pkgs.ripgrep
            pkgs.tree
            pkgs.yazi
            pkgs.wget
        ];
    };

    flake.modules.darwin.packages = {
        inputs,
        pkgs,
        ...
    }: {
        programs = {
            _1password-gui.enable = true;
        };
        environment.systemPackages = [
            inputs.self.packages.${pkgs.system}.nvim
            pkgs.bat
            pkgs.bottom
            pkgs.curl
            pkgs.eza
            pkgs.fd
            pkgs.fish
            pkgs.gitu
            pkgs.gnupg
            pkgs.gh
            pkgs.gh-dash
            pkgs.htop
            pkgs.jq
            pkgs.just
            pkgs.nix-output-monitor
            pkgs.prr
            pkgs.ripgrep
            pkgs.tree
            pkgs.yazi
            pkgs.wget
            pkgs._1password-cli
            pkgs.claude-code
            pkgs.hurl
            pkgs.iina
            pkgs.broot
            pkgs.jira-cli-go
            pkgs.lazydocker
            pkgs.pika
            pkgs.raycast
            pkgs.rainfrog
            pkgs.tmux-sessionizer
            pkgs.wiki-tui
            pkgs.bat
            pkgs.bottom
            pkgs.curl
            pkgs.eza
            pkgs.fd
            pkgs.fish
            pkgs.gitu
            pkgs.gnupg
            pkgs.gh
            pkgs.gh-dash
            pkgs.htop
            pkgs.jq
            pkgs.just
            pkgs.nix-output-monitor
            pkgs.prr
            pkgs.ripgrep
            pkgs.tree
            pkgs.yazi
            pkgs.wget
        ];
        homebrew = {
            enable = true;
            caskArgs.no_quarantine = true;
            onActivation = {
                autoUpdate = true;
                upgrade = true;
            };
            casks = [
                "docker-desktop"
                "losslessswitcher"
                "ghostty"
                "onyx"
                "sabnzbd"
                "slack"
                "tableplus"
            ];
        };
    };

    flake.modules.homeManager.packages = {
        programs.direnv = {
            enable = true;
            silent = true;
        };
        programs.opencode = {
            enable = true;
            settings = {
                theme = "opencode";
                model = "anthropic/claude-sonnet-4-20250514";
                autoshare = false;
                autoupdate = true;
            };
        };
    };
}
