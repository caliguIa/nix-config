# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

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

  users = {
    users = {
      caligula = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "share"
        ];
      };
      share = {
        isSystemUser = true;
        group = "share";
        uid = 994;
      };
    };
    groups = {
      share = {
        gid = 993;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    curl
    git
    tmux
    vnstat
    cloudflared
  ];

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;
  services.jellyfin = {
    enable = true;
    user = "share";
    group = "share";
  };
  services.sabnzbd = {
    enable = true;
    configFile = "/var/lib/sabnzbd/sabnzbd.ini";
    openFirewall = true;
    user = "share";
    group = "share";
  };
  services.audiobookshelf = {
    enable = true;
    port = 8113;
    host = "0.0.0.0";
    user = "share";
    group = "share";
  };

  services.cloudflared = {
    enable = true;
    certificateFile = "/home/caligula/.cloudflared/cert.pem";
    tunnels = {
      "93cd8f38-e60c-4b91-8e46-c7d8c5273350" = {
        credentialsFile = "/var/lib/cloudflared/93cd8f38-e60c-4b91-8e46-c7d8c5273350.json";
        default = "http_status:404";
      };
      "4ea6e900-1983-443e-82bc-a7607fecd5e4" = {
        credentialsFile = "/home/caligula/.cloudflared/4ea6e900-1983-443e-82bc-a7607fecd5e4.json";
        default = "http_status:404";
        ingress = {
          "audiobooks.calrichards.io" = {
            service = "http://localhost:8113";
          };
        };
      };
    };
  };

  # auto standby
  services.cron.systemCronJobs = [ "0 1 * * * root rtcwake -m mem --date +6h" ];

  # NOTE: need to run `sudo smbpasswd -a <username>` to be able to log in
  services.samba = {
    enable = true;
    settings = {
      "audiobooks" = {
        "path" = "/home/audiobooks";
        "valid users" = [ "caligula" ];
        "fruit:aapl" = "yes";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "movies" = {
        "path" = "/home/movies";
        "valid users" = [ "caligula" ];
        "fruit:aapl" = "yes";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "tv" = {
        "path" = "/home/tv";
        "valid users" = [ "caligula" ];
        "fruit:aapl" = "yes";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };

  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable";
  system.stateVersion = "24.11";
}
