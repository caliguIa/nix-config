{...}: {
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
            format = "$directory $git_branch$git_status $git_state $fill $cmd_duration$line_break$character";
            directory.style = "bold fg:#CCCCCC";
            fill.symbol = " ";
            character = {
                success_symbol = "[](#7C7C7C)";
                error_symbol = "[](#7C7C7C)";
                vimcmd_symbol = "[](#7C7C7C)";
            };
            git_branch = {
                format = "[$branch]($style)";
                style = "fg:#B8B8B8";
            };
            git_status = {
                format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](#7C7C7C) ($ahead_behind$stashed)](#7C7C7C)";
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
                style = "#7C7C7C";
            };
            cmd_duration = {
                format = "[$duration]($style) ";
                style = "fg:#7C7C7C";
            };
        };
        enableFishIntegration = true;
    };
}
