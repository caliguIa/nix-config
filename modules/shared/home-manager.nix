{
  config,
  pkgs,
  lib,
  ...
}:

{
  alacritty = { } // import ./packages/alacritty.nix { inherit pkgs; };
  atuin = { } // import ./packages/atuin.nix { inherit pkgs; };
  bat = { } // import ./packages/bat.nix { inherit pkgs; };
  fzf = { } // import ./packages/fzf.nix { inherit pkgs; };
  git = { } // import ./packages/git.nix { inherit pkgs; };
  gitui = { } // import ./packages/gitui.nix { inherit pkgs; };
  helix = { } // import ./packages/helix.nix { inherit pkgs lib; };
  ncspot = { } // import ./packages/ncspot.nix { inherit pkgs; };
  neovim = { } // import ./packages/neovim.nix { inherit pkgs; };
  opam = { } // import ./packages/opam.nix { inherit pkgs; };
  starship = { } // import ./packages/starship.nix { inherit pkgs; };
  tmux = { } // import ./packages/tmux.nix { inherit pkgs; };
  zellij = { } // import ./packages/zellij.nix { inherit pkgs; };
  zsh = { } // import ./packages/zsh.nix { inherit config pkgs; };
}
