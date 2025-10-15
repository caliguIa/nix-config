let
    themeConfig = import ./themes;
    fzf = themeConfig.fzf;
in {
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
            bg = fzf.bg;
            "bg+" = fzf.bg_plus;
            preview-bg = fzf.preview_bg;
            fg = fzf.fg;
            "fg+" = fzf.fg_plus;
            preview-fg = fzf.preview_fg;
            hl = fzf.hl;
            "hl+" = fzf.hl_plus;
            info = fzf.info;
            border = fzf.border;
            prompt = fzf.prompt;
            pointer = fzf.pointer;
            marker = fzf.marker;
            spinner = fzf.spinner;
            header = fzf.header;
        };
    };
}
