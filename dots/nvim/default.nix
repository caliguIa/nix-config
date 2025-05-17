{ 
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      docker-compose-language-service
      dockerfile-language-server-nodejs
      intelephense
      lua-language-server
      marksman
      nil
      nixfmt-rfc-style
      nodePackages.prettier
      phpactor
      php82Packages.composer
      prettierd
      rust-analyzer
      sleek
      stylua
      typescript
      vscode-langservers-extracted
      vtsls
      zig
    ];
  };

  # Link Neovim config files to ~/.config/nvim
  home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dots/nvim/files/nvim";
      recursive = true;
  };
}
