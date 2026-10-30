# LSP servers and formatters on nvim's PATH.
# Not autoimported (leading underscore); import with `import ./_editor-tools.nix { inherit pkgs; }`.
{ pkgs }:
let
    stylelint-language-server = pkgs.writeShellApplication {
        name = "stylelint-language-server";
        runtimeInputs = [ pkgs.nodejs ];
        text =
            let
                ext = pkgs.vscode-extensions.stylelint.vscode-stylelint;
            in
            ''exec node ${ext}/share/vscode/extensions/stylelint.vscode-stylelint/dist/start-server.js "$@"'';
    };
in
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
