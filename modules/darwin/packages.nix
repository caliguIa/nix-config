{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  aldente
  discord
  grandperspective
  keka
  gnused
  (writeShellScriptBin "gsed" ''exec ${pkgs.gnused}/bin/sed "$@"'')
  pam-reattach
  raycast
  rectangle
  slack
  spotify
  stats
  utm
]
