{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; in
{

    "${xdg_configHome}/skhd/skhdrc" = {
        text = ''
            hyper - a : /usr/bin/open -a Alacritty
            hyper - s : /usr/bin/open -a Arc
            hyper - d : /usr/bin/open -a Slack
        '';
    };

    "${xdg_configHome}/karabiner/karabiner.json" = {
        text = builtins.readFile ../darwin/config/karabiner/karabiner.json;
    };
}
