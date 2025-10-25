{
    flake.modules.homeManager.desktop = {
        programs.fzf = {
            enable = true;
            enableZshIntegration = true;
            enableFishIntegration = true;
            defaultCommand = "fd --type f --hidden --follow --exclude .git --exclude .vim --exclude .cache --exclude vendor --exclude node_modules";
            defaultOptions = ["--inline-info"];
            tmux = {
                enableShellIntegration = true;
            };
        };
    };
}
