{ pkgs }:

with pkgs;
[
  # Core utilities needed on both systems
  bat
  bottom
  cmake
  eza
  fd
  just
  less
  ripgrep
  # Add tmux since it's referenced in your list
  tmux
]