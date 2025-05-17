{
  lib,
  pkgs,
  system,
  hostname,
  username,
  ...
}:

let
  isDarwin = lib.strings.hasInfix "darwin" system;
  isNixOS = lib.strings.hasInfix "linux" system;
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  # Import common program configurations
  imports = [
    # Core program configurations used on all systems
    ../../dots/git
    ../../dots/zsh
    ../../dots/nvim
    ../../dots/starship
    ../../dots/fzf
    ../../dots/atuin
    ../../dots/tmux
    ../../dots/bin
  ];

  # Home Manager configuration
  home = {
    username = username;
    homeDirectory = homeDirectory;

    # Basic file configuration (not tied to specific programs)
    file = {
      ".hushlogin".text = "";
    };

    # State version for Home Manager
    stateVersion = if isDarwin then "23.11" else "24.11";
  };

  # Enable home-manager
  programs.home-manager.enable = true;
}
