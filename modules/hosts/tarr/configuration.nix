{
    flake.modules.nixos.host_tarr = {config, pkgs, ...}: {
	  boot.loader.systemd-boot.enable = true;
	  boot.loader.efi.canTouchEfiVariables = true;

	  boot.kernelPackages = pkgs.linuxPackages_latest;

	  networking.hostName = "tarr"; # Define your hostname.
	  networking.networkmanager.enable = true;

	  time.timeZone = "Europe/London";

	  i18n.defaultLocale = "en_GB.UTF-8";

	  i18n.extraLocaleSettings = {
	    LC_ADDRESS = "en_GB.UTF-8";
	    LC_IDENTIFICATION = "en_GB.UTF-8";
	    LC_MEASUREMENT = "en_GB.UTF-8";
	    LC_MONETARY = "en_GB.UTF-8";
	    LC_NAME = "en_GB.UTF-8";
	    LC_NUMERIC = "en_GB.UTF-8";
	    LC_PAPER = "en_GB.UTF-8";
	    LC_TELEPHONE = "en_GB.UTF-8";
	    LC_TIME = "en_GB.UTF-8";
	  };

	  programs.neovim.enable = true;
	  programs.git.enable = true;

	  # Enable the X11 windowing system.
	  # You can disable this if you're only using the Wayland session.
	  services.xserver.enable = true;

	  # Enable the KDE Plasma Desktop Environment.
	  services.displayManager.sddm.enable = true;
	  services.desktopManager.plasma6.enable = true;

	  # Configure keymap in X11
	  services.xserver.xkb = {
	    layout = "us";
	    variant = "";
	  };

	  # Enable sound with pipewire.
	  services.pulseaudio.enable = false;
	  security.rtkit.enable = true;
	  services.pipewire = {
	    enable = true;
	    alsa.enable = true;
	    alsa.support32Bit = true;
	    pulse.enable = true;
	    # If you want to use JACK applications, uncomment this
	    #jack.enable = true;

	    # Use the WirePlumber session manager
	    #wireplumber.enable = true;
	  };

	  # Enable touchpad support (enabled default in most desktopManager).
	  # services.libinput.enable = true;

	  # Define a user account. Don't forget to set a password with ‘passwd’.
	  users.users."caligula" = {
	    isNormalUser = true;
	    description = "caligula";
	    extraGroups = [ "networkmanager" "wheel" ];
	    packages = with pkgs; [
	      kdePackages.kate
	    #  thunderbird
	    ];
	  };

	  programs.firefox.enable = true;

	  nixpkgs.config.allowUnfree = true;
	  services.openssh.enable = true;
	  system.stateVersion = "26.05"; 
    };
}
