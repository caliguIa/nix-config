{ ... }: {
  enable = true;
  enableZshIntegration = true;
  settings = {
    format =
      "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$character";
    directory = { style = "yellow"; };
    character = {
      success_symbol = "[❯](yellow)";
      error_symbol = "[❯](red)";
      vimcmd_symbol = "[❮](green)";
    };
    git_branch = {
      format = "[$branch]($style)";
      style = "green";
    };
    git_status = {
      format =
        "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
      style = "cyan";
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
      style = "bright-black";
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "yellow";
    };
  };
}
