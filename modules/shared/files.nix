{ user, config, ... }:

let
  xdg_confighome = "${config.users.users.${user}.home}/.config";
  neovimconfighome = "${config.users.users.${user}.home}/.config/nvim";
in
{
  ".hushlogin" = {
    text = "";
  };
  "${neovimconfighome}/init.lua" = {
    text = builtins.readFile ./config/neovim/init.lua;
  };
  "${neovimconfighome}/lua/caligula/init.lua" = {
    text = builtins.readFile ./config/neovim/lua/caligula/init.lua;
  };
  "${neovimconfighome}/lua/caligula/autocmds.lua" = {
    text = builtins.readFile ./config/neovim/lua/caligula/autocmds.lua;
  };
  "${neovimconfighome}/lua/caligula/plugins.lua" = {
    text = builtins.readFile ./config/neovim/lua/caligula/plugins.lua;
  };
  "${neovimconfighome}/lua/caligula/remap.lua" = {
    text = builtins.readFile ./config/neovim/lua/caligula/remap.lua;
  };
  "${neovimconfighome}/lua/caligula/set.lua" = {
    text = builtins.readFile ./config/neovim/lua/caligula/set.lua;
  };
  "${neovimconfighome}/after/plugin/cmp.lua" = {
    text = builtins.readFile ./config/neovim/after/plugin/cmp.lua;
  };
  "${neovimconfighome}/after/plugin/colour.lua" = {
    text = builtins.readFile ./config/neovim/after/plugin/colour.lua;
  };
  "${neovimconfighome}/after/plugin/harpoon.lua" = {
    text = builtins.readFile ./config/neovim/after/plugin/harpoon.lua;
  };
  "${neovimconfighome}/after/plugin/lsp.lua" = {
    text = builtins.readFile ./config/neovim/after/plugin/lsp.lua;
  };
  "${neovimconfighome}/after/plugin/telescope.lua" = {
    text = builtins.readFile ./config/neovim/after/plugin/telescope.lua;
  };
  "${neovimconfighome}/after/plugin/treesitter.lua" = {
    text = builtins.readFile ./config/neovim/after/plugin/treesitter.lua;
  };
  "${neovimconfighome}/after/plugin/folds.lua" = {
    text = builtins.readFile ./config/neovim/after/plugin/folds.lua;
  };
  "${xdg_confighome}/tmuxinator/mono.yml" = {
    text = builtins.readFile ./config/tmuxinator/mono.yml;
  };
  "${xdg_confighome}/tmuxinator/players.yml" = {
    text = builtins.readFile ./config/tmuxinator/players.yml;
  };
  "${xdg_confighome}/tmuxinator/r18.yml" = {
    text = builtins.readFile ./config/tmuxinator/r18.yml;
  };
  "${xdg_confighome}/spotify-player/app.toml" = {
    text = builtins.readFile ./config/spotify-player/app.toml;
  };
  "${xdg_confighome}/spotify-player/theme.toml" = {
    text = builtins.readFile ./config/spotify-player/theme.toml;
  };
}
