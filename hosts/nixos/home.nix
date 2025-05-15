{
  config,
  pkgs,
  ...
}: {
  # Home Manager configuration for NixOS
  # This imports shared configuration but can also contain
  # settings specific to the NixOS environment
  imports = [
    ../../modules/shared/home-manager.nix
  ];

  # You can add additional home-manager configurations specific to NixOS here
  programs.bash.enable = true;
  
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "caligula";
  home.homeDirectory = "/home/caligula";
  
  # The home.stateVersion should match your NixOS version
  home.stateVersion = "24.11";
}