{pkgs, ...}: {
    programs = {
        _1password-gui.enable = true;
    };
    environment.systemPackages = [
        pkgs._1password-cli
        pkgs.claude-code
        pkgs.iina
        pkgs.jira-cli-go
        pkgs.lazydocker
        pkgs.pika
        pkgs.raycast
        pkgs.rainfrog
        pkgs.tmux-sessionizer
        pkgs.wiki-tui
    ];
}
