{...}: {
    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        defaultCommand = "fd --type f --hidden --follow --exclude .git --exclude .vim --exclude .cache --exclude vendor --exclude node_modules";
        defaultOptions = ["--inline-info"];
        tmux = {
            enableShellIntegration = true;
        };
        colors = {
            bg = "#333333";
            "bg+" = "#333333";
            preview-bg = "#333333";
            fg = "#C2C2C2";
            "fg+" = "#CCCCCC";
            preview-fg = "#C2C2C2";
            hl = "#474747";
            "hl+" = "#474747";
            info = "#686868";
            border = "#333333";
            prompt = "#474747";
            pointer = "#474747";
            marker = "#474747";
            spinner = "#474747";
            header = "#474747";
        };
    };
}
