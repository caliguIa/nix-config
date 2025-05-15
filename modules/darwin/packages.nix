{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
  darwin-specific = [
    # Darwin-specific packages
    _1password-cli
    aerospace
    awscli2
    cargo
    claude-code
    docker
    deno
    exercism
    gitu
    gh
    iina
    image_optim
    jq
    keka
    killport
    lazydocker
    lazysql
    lima
    lua
    nerd-fonts.iosevka
    nushell
    pam-reattach
    pkg-config
    portaudio
    python3
    rainfrog
    raycast
    rustc
    sd
    spotify
    tokei
    wezterm
    wget
    yazi
  ];
in
shared-packages ++ darwin-specific
