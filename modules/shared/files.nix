{ user, config, ... }:

let
  xdgConfigHome = "${config.users.users.${user}.home}/.config";
  neovimConfigHome = "${config.users.users.${user}.home}/.config/nvim";
in
{
  ".hushlogin".text = "";
  "${neovimConfigHome}/init.lua".source = ./config/neovim/init.lua;
  "${neovimConfigHome}/lua".source =  ./config/neovim/lua;
  "${neovimConfigHome}/after".source = ./config/neovim/after;
  "${xdgConfigHome}/tmuxinator".source =  ./config/tmuxinator;
  "${xdgConfigHome}/spotify-player".source = ./config/spotify-player;
}
