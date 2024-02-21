{ user, config, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
in
{

  #"${xdg_configHome}/skhd/skhdrc" = {
  #  text = ''
  #    hyper - a : /usr/bin/open -a Alacritty
  #    hyper - s : /usr/bin/open -a Arc
  #    hyper - d : /usr/bin/open -a Slack
  #  '';
  #};

  "${xdg_configHome}/karabiner/karabiner.json" = {
    text = builtins.readFile ../darwin/config/karabiner/karabiner.json;
  };
}
