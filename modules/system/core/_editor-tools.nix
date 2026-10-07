# LSP servers and formatters shared by nvim and helix.
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

    mago = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "mago";
        version = "1.45.0";
        src = pkgs.fetchurl {
            url = "https://github.com/carthage-software/mago/releases/download/${finalAttrs.version}/mago-${finalAttrs.version}-x86_64-unknown-linux-musl.tar.gz";
            hash = "sha256-aNsEDrmx3uGPvf9iTBN1TPdM0z58W2CZHh/jX9mxkNE=";
        };
        installPhase = ''
            runHook preInstall
            install -Dm755 mago "$out/bin/mago"
            runHook postInstall
        '';
    });
in
{
    inherit mago;

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
