{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _1password-cli
    aerospace
    awscli2
    cargo
    claude-code
    docker
    gh
    iina
    keka
    killport
    lazydocker
    lima
    lua
    nerd-fonts.iosevka
    nodejs
    pam-reattach
    pkg-config
    python3
    raycast
    rustc
    sd
    spotify
    tokei
    wezterm
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.opam = {
    enable = false;
    enableZshIntegration = true;
  };
}
