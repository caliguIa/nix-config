{
  config,
  pkgs,
  lib,
  neovim-nightly-overlay,
  ...
}:

{
  # Only include the core packages needed on both systems
  atuin = { } // import ./packages/atuin.nix { inherit pkgs; };
  bat = { } // import ./packages/bat.nix { inherit pkgs; };
  fzf = { } // import ./packages/fzf.nix { inherit pkgs; };
  git = { } // import ./packages/git.nix { inherit pkgs; };
  neovim =
    { }
    // import ./packages/neovim.nix {
      inherit
        neovim-nightly-overlay
        pkgs
        ;
    };
  starship = { } // import ./packages/starship.nix { inherit pkgs; };
  zsh = { } // import ./packages/zsh.nix { inherit config lib; };
}
