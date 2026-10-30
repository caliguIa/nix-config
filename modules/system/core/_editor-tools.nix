# LSP servers and formatters on nvim's PATH.
# Not autoimported (leading underscore); import with `import ./_editor-tools.nix { inherit pkgs; }`.
{ pkgs }:
{
    tools = with pkgs; [
        # lsp
        emmylua-ls
        nixd
        taplo
        bash-language-server
        marksman
        docker-compose-language-service
        dockerfile-language-server
        vscode-langservers-extracted
        intelephense
        typescript
        # typescript-language-server
        oxlint
        sqls
        stylelint-language-server
        yaml-language-server
        phpantom-lsp
        # formatter
        nixfmt
        stylua
        sqruff
        vtsls
    ];
}
