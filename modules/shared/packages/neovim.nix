{
  pkgs,
  zls,
  ...
}:
{
  enable = true;
  # package = neovim-nightly-overlay.packages.${pkgs.system}.default;
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
    rust-analyzer
    sleek
    stylua
    typescript
    vscode-langservers-extracted
    vtsls
    zls.packages.${pkgs.system}.default
  ];
}
