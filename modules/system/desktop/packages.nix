{ inputs, ... }: {
  flake.modules.nixos.desktop = { pkgs, ... }: {
    services.dbus.enable = true;
    services.mullvad-vpn.enable = true;
    programs.dconf.enable = true;
    programs.nix-ld = {
      enable = true;
      libraries = [ ];
    };
    programs.thunderbird.enable = true;
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };
    environment.sessionVariables = {
      OPENCODE_EXPERIMENTAL_OXFMT = "true";
      MOZ_DISABLE_RDD_SANDBOX = "1";
    };
    environment.systemPackages = with pkgs; [
      inputs.zen-browser.packages."${pkgs.stdenvNoCC.hostPlatform.system}".twilight
      ungoogled-chromium
      gelly
      sourcegit
      opencode
      claude-code
      bitwarden-cli
      bitwarden-desktop
      mullvad-vpn
      mullvad
    ];
  };
}
