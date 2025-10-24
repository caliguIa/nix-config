{
    flake.modules.homeManager.fzf = {self, ...}: let
        themeConfig = import (self + /utils/colours);
        colours = themeConfig.fzf;
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
                bg = colours.bg;
                "bg+" = colours.bg_plus;
                preview-bg = colours.preview_bg;
                fg = colours.fg;
                "fg+" = colours.fg_plus;
                preview-fg = colours.preview_fg;
                hl = colours.hl;
                "hl+" = colours.hl_plus;
                info = colours.info;
                border = colours.border;
                prompt = colours.prompt;
                pointer = colours.pointer;
                marker = colours.marker;
                spinner = colours.spinner;
                header = colours.header;
            };
        };
    };
}
