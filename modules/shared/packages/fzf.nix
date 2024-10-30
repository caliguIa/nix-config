{ ... }:
{
  enable = true;
  enableZshIntegration = true;
  defaultCommand = "fd --type f --hidden --follow --exclude .git --exclude .vim --exclude .cache --exclude vendor --exclude node_modules";
  defaultOptions = [ "--inline-info" ];
  colors = {
    # melange

    bg = "#292522";
    "bg+" = "#292522";
    fg = "#ECE1D7";
    "fg+" = "#ECE1D7";
    hl = "#ff9e64";
    "hl+" = "#ff9e64";
    info = "#EBC06D";
    prompt = "#A3A9CE";
    pointer = "#A3A9CE";
    marker = "#A3A9CE";
    spinner = "#A3A9CE";
    header = "#9ece6a";

    # tokyonight

    # bg = "#1a1b26";
    # "bg+" = "#292e42";
    # fg = "#c0caf5";
    # "fg+" = "#c0caf5";
    # hl = "#ff9e64";
    # "hl+" = "#ff9e64";
    # info = "#7aa2f7";
    # prompt = "#7dcfff";
    # pointer = "#7dcfff";
    # marker = "#9ece6a";
    # spinner = "#9ece6a";
    # header = "#9ece6a";
  };
}
