{
  config,
  pkgs,
  lib,
  zls,
  neovim-nightly-overlay,
  ...
}:

{
  alacritty = { } // import ./packages/alacritty.nix { inherit pkgs; };
  atuin = { } // import ./packages/atuin.nix { inherit pkgs; };
  bat = { } // import ./packages/bat.nix { inherit pkgs; };
  direnv = { } // import ./packages/direnv.nix { inherit pkgs; };
  fzf = { } // import ./packages/fzf.nix { inherit pkgs; };
  git = { } // import ./packages/git.nix { inherit pkgs; };
  helix = { } // import ./packages/helix.nix { inherit pkgs lib; };
  lazygit = { } // import ./packages/lazygit.nix { inherit pkgs; };
  ncspot = { } // import ./packages/ncspot.nix { inherit pkgs; };
  neovim =
    { }
    // import ./packages/neovim.nix {
      inherit
        neovim-nightly-overlay
        pkgs
        zls
        ;
    };
  opam = { } // import ./packages/opam.nix { inherit pkgs; };
  starship = { } // import ./packages/starship.nix { inherit pkgs; };
  zellij = { } // import ./packages/zellij.nix { inherit pkgs; };
  zsh = { } // import ./packages/zsh.nix { inherit config lib; };
}
