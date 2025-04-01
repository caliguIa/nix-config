{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  aerospace
  keka
  pam-reattach
  pkg-config
  portaudio
  raycast
  slack
  spotify
]
