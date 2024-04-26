{ user, config, ... }:

let neovimConfigHome = "${config.users.users.${user}.home}/.config/nvim";
in {
  ".hushlogin".text = "";
  "${neovimConfigHome}/init.lua".source = ./config/neovim/init.lua;
  "${neovimConfigHome}/lua".source = ./config/neovim/lua;
}
