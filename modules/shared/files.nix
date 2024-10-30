{ ... }:

{
  ".hushlogin".text = "";
  ".config/wezterm" = {
    source = ./config/wezterm;
    recursive = true;
  };
}
