{
    pkgs,
    inputs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        claude-code
        inputs.self.outputs.neovim.packages.${pkgs.system}.nvim
        tmux-sessionizer
        youtube-tui
    ];
}
