{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  aerospace
  colima
  discord
  grandperspective
  keka
  pam-reattach
  raycast
  rectangle
  slack
  spotify
  utm
  wezterm
]
