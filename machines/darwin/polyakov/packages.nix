{
    pkgs,
    inputs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        bacon
        claude-code
        iina
        inputs.self.outputs.neovim.packages.${pkgs.system}.nvim
        libsixel
        lima
        presenterm
        tmux-sessionizer
        youtube-tui
        yt-dlp
        wiki-tui
    ];
}
