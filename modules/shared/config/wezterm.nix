{ ... }:
{
  enable = true;
  extraConfig = builtins.readFile ../files/wezterm.lua;
}
