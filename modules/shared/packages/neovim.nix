{
  neovim-nightly-overlay,
  pkgs,
  zls,
  ...
}:
{
  enable = true;
  package = neovim-nightly-overlay.packages.${pkgs.system}.default;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  withPython3 = true;
  extraPackages = with pkgs; [
    eslint
    docker-compose-language-service
    dockerfile-language-server-nodejs
    hadolint
    intelephense
    lua-language-server
    markdownlint-cli2
    marksman
    nil
    nixfmt-rfc-style
    nodePackages.prettier
    nodePackages_latest.vscode-json-languageserver
    php82Packages.composer
    rust-analyzer
    stylua
    sqlfluff
    typescript
    typescript-language-server
    vscode-langservers-extracted
    vtsls
    zls.packages.${pkgs.system}.default
  ];
}
