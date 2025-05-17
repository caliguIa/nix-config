{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory $git_branch$git_status $git_state $fill $cmd_duration$line_break$character";
      directory = {
        style = "bold fg:#d5d5d5";
      };
      fill = {
        symbol = " ";
      };
      character = {
        success_symbol = "[](#ff0088)";
        error_symbol = "[](#ff0088)";
        vimcmd_symbol = "[](#ff0088)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "fg:#949494";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](#ff0088) ($ahead_behind$stashed)](#51657B)";
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
        style = "#737373";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "fg:#737373";
      };
    };
  };
}