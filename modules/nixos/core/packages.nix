{
    flake.modules.darwin.core = {pkgs, ...}: {
        programs = {
            _1password-gui.enable = true;
        };
        environment.systemPackages = with pkgs; [
            # inputs.self.packages.${pkgs.system}.nvim
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
            pkgs.hurl
            pkgs.iina
            pkgs.broot
            pkgs.jira-cli-go
            pkgs.lazydocker
            pkgs.pika
            pkgs.raycast
            pkgs.wiki-tui
        ];
    };

    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            # inputs.self.packages.${pkgs.system}.nvim
            pkgs.bat
            pkgs.bottom
            pkgs.curl
            pkgs.eza
            pkgs.fd
            pkgs.fish
            pkgs.gitu
            pkgs.gnupg
            pkgs.gh
            pkgs.htop
            pkgs.jq
            pkgs.just
            pkgs.nix-output-monitor
            pkgs.ripgrep
            pkgs.tree
            pkgs.yazi
            pkgs.wget
        ];
    };
}
