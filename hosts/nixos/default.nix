{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Import hardware configuration directly from its system location
    /etc/nixos/hardware-configuration.nix
    # Import specific NixOS modules
    ../../modules/nixos
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # network configuration
  networking = {
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.1.1";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.0.1";
    nameservers = [ "8.8.8.8" ];
    hostName = "george";
    firewall.enable = false;
  };

  time.timeZone = "Europe/London";

  nixpkgs.config.allowUnfree = true;

  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable";
  system.stateVersion = "24.11";
}