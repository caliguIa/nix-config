{
    flake.modules.homeManager.core = {
        programs.starship = {
            enable = true;
            enableZshIntegration = true;
            enableFishIntegration = true;
            settings = {
                format = "$directory $git_branch$git_status $git_state $fill $cmd_duration$line_break$character";
                fill.symbol = " ";
                git_branch.format = "[$branch]($style)";
                git_status = {
                    format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)]($style) ($ahead_behind$stashed)]($style)";
                    conflicted = "​";
                    untracked = "​";
                    modified = "​";
                    staged = "​";
                    renamed = "​";
                    deleted = "​";
                    stashed = "≡";
                };
                git_state.format = "([$state( $progress_current/$progress_total)]($style)) ";
                cmd_duration.format = "[$duration]($style) ";
            };
        };
    };
}
