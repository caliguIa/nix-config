{self, ...}: {
    flake.modules.homeManager.core = let
        themeConfig = import (self + /utils/colours);
        colours = themeConfig.starship;
    in {
        programs.starship = {
            enable = true;
            enableZshIntegration = true;
            settings = {
                format = "$directory $git_branch$git_status $git_state $fill $cmd_duration$line_break$character";
                directory.style = colours.directory_style;
                fill.symbol = " ";
                character = {
                    success_symbol = colours.character_success;
                    error_symbol = colours.character_error;
                    vimcmd_symbol = colours.character_vim;
                };
                git_branch = {
                    format = "[$branch]($style)";
                    style = colours.git_branch_style;
                };
                git_status = {
                    format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](${colours.git_status_style}) ($ahead_behind$stashed)](${colours.git_status_style})";
                    conflicted = "​";
                    untracked = "​";
                    modified = "​";
                    staged = "​";
                    renamed = "​";
                    deleted = "​";
                    stashed = "≡";
                };
                git_state = {
                    format = "([$state( $progress_current/$progress_total)]($style)) ";
                    style = colours.git_state_style;
                };
                cmd_duration = {
                    format = "[$duration]($style) ";
                    style = colours.cmd_duration_style;
                };
            };
            enableFishIntegration = true;
        };
    };
}
