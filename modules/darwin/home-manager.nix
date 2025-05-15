{
  config,
  pkgs,
  lib,
  ...
}:

{
  direnv = { } // import ../shared/packages/direnv.nix { inherit pkgs; };
  lazygit = { } // import ../shared/packages/lazygit.nix { inherit pkgs; };
  opam = { } // import ../shared/packages/opam.nix { inherit pkgs; };
}
