{ ... }:

{
  ".hushlogin".text = "";
  ".config/kanata".source = ./config/kanata;
  ".config/wezterm" = {
    source = ./config/wezterm;
    recursive = true;
  };
}
