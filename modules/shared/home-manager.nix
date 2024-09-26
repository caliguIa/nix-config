{
  config,
  pkgs,
  lib,
  ...
}:

{
  alacritty = { } // import ./config/alacritty.nix { inherit pkgs; };
  atuin = { } // import ./config/atuin.nix { inherit pkgs; };
  bat = { } // import ./config/bat.nix { inherit pkgs; };
  fzf = { } // import ./config/fzf.nix { inherit pkgs; };
  git = { } // import ./config/git.nix { inherit pkgs; };
  gitui = { } // import ./config/gitui.nix { inherit pkgs; };
  helix = { } // import ./config/helix.nix { inherit pkgs lib; };
  neovim = { } // import ./config/neovim.nix { inherit pkgs; };
  opam = { } // import ./config/opam.nix { inherit pkgs; };
  starship = { } // import ./config/starship.nix { inherit pkgs; };
  tmux = { } // import ./config/tmux.nix { inherit pkgs; };
  zellij = { } // import ./config/zellij.nix { inherit pkgs; };
  zsh = { } // import ./config/zsh.nix { inherit config pkgs; };
}
