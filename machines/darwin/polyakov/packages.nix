{
    pkgs,
    inputs,
    ...
}: {
    programs = {
        _1password-gui.enable = true;
    };
    environment.systemPackages = with pkgs; [
        _1password-cli
        claude-code
        iina
        inputs.self.outputs.neovim.packages.${pkgs.system}.nvim
        jira-cli-go
        lazydocker
        pika
        raycast
        tmux-sessionizer
        wiki-tui
    ];
}
