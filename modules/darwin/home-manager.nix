{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Program configurations specific to Darwin
  # alacritty = { } // import ../shared/packages/alacritty.nix { inherit pkgs; };
  direnv = { } // import ../shared/packages/direnv.nix { inherit pkgs; };
  fzf = { } // import ../shared/packages/fzf.nix { inherit pkgs; };
  git = { } // import ../shared/packages/git.nix { inherit pkgs; };
  helix = { } // import ../shared/packages/helix.nix { inherit pkgs lib; };
  lazygit = { } // import ../shared/packages/lazygit.nix { inherit pkgs; };
  ncspot = { } // import ../shared/packages/ncspot.nix { inherit pkgs; };
  opam = { } // import ../shared/packages/opam.nix { inherit pkgs; };
  zellij = { } // import ../shared/packages/zellij.nix { inherit pkgs; };
}

