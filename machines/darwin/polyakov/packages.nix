{
    pkgs,
    inputs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        claude-code
        inputs.self.outputs.nixCats.packages.${pkgs.system}.nvim
        tmux-sessionizer
        youtube-tui
    ];
}
