{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  aerospace
  colima
  keka
  pam-reattach
  slack
  spotify
  utm
  wezterm
]
