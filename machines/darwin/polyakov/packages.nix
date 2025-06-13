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
        bacon
        claude-code
        colima
        firefox
        iina
        inputs.self.outputs.neovim.packages.${pkgs.system}.nvim
        lazydocker
        libsixel
        lima
        pika
        presenterm
        tmux-sessionizer
        youtube-tui
        yt-dlp
        wiki-tui
    ];
}
