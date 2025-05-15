{
  config,
  pkgs,
  lib,
  zls,
  neovim-nightly-overlay,
  ...
}:

{
  # Only include the core packages needed on both systems
  atuin = { } // import ./packages/atuin.nix { inherit pkgs; };
  bat = { } // import ./packages/bat.nix { inherit pkgs; };
  neovim =
    { }
    // import ./packages/neovim.nix {
      inherit
        neovim-nightly-overlay
        pkgs
        zls
        ;
    };
  starship = { } // import ./packages/starship.nix { inherit pkgs; };
  zsh = { } // import ./packages/zsh.nix { inherit config lib; };
}