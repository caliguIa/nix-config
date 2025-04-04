{ ... }:
{
  enable = true;
  enableZshIntegration = true;
  defaultCommand = "fd --type f --hidden --follow --exclude .git --exclude .vim --exclude .cache --exclude vendor --exclude node_modules";
  defaultOptions = [ "--inline-info" ];
  tmux = {
    enableShellIntegration = true;
  };
  colors = {
    bg = "#121212";
    "bg+" = "#121212";
    preview-bg = "#121212";
    fg = "#b4b4b4";
    "fg+" = "#f5f5f5";
    preview-fg = "#b4b4b4";
    hl = "#ff0088";
    "hl+" = "#f5f5f5";
    info = "#d5d5d5";
    border = "#121212";
    prompt = "#ff0088";
    pointer = "#ff0088";
    marker = "#ff0088";
    spinner = "#ff0088";
    header = "#ff0088";
  };
}
