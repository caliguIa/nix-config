{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  discord
  grandperspective
  karabiner-elements
  keka
  pam-reattach
  raycast
  rectangle
  slack
  skhd
  spotify
  stats
  utm
]
