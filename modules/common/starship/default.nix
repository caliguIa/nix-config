let
    themeConfig = import ../themes;
    starship = themeConfig.starship;
in
{
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
            format = "$directory $git_branch$git_status $git_state $fill $cmd_duration$line_break$character";
            directory.style = starship.directory_style;
            fill.symbol = " ";
            character = {
                success_symbol = starship.character_success;
                error_symbol = starship.character_error;
                vimcmd_symbol = starship.character_vim;
            };
            git_branch = {
                format = "[$branch]($style)";
                style = starship.git_branch_style;
            };
            git_status = {
                format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](${starship.git_status_style}) ($ahead_behind$stashed)](${starship.git_status_style})";
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
                style = starship.git_state_style;
            };
            cmd_duration = {
                format = "[$duration]($style) ";
                style = starship.cmd_duration_style;
            };
        };
        enableFishIntegration = true;
    };
}
