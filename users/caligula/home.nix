{
  pkgs,
  username,
  homeDirectory,
  ...
}: {
  # Enable home-manager
  programs.home-manager.enable = true;
  
  # Set basic home-manager configuration
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "24.11";
    
    # Create .hushlogin file
    file = {".hushlogin".text = "";};
  };
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Import all the modules for this user
  imports = [
    # Shell
    ../../modules/common/fish
    ../../modules/common/zsh
    
    # Tools
    ../../modules/common/atuin
    ../../modules/common/fzf
    ../../modules/common/git
    ../../modules/common/starship
    ../../modules/common/tmux
  ];
}