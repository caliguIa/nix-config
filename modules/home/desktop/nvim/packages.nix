{inputs, ...}: {
    flake.meta.nvimExtraPackages = pkgs: let
        stylelint-language-server = let
            ext = pkgs.vscode-extensions.stylelint.vscode-stylelint;
            server = "${ext}/share/vscode/extensions/stylelint.vscode-stylelint/dist/start-server.js";
        in
            pkgs.writeShellApplication {
                name = "stylelint-language-server";
                runtimeInputs = [pkgs.nodejs];
                text = ''exec node ${server} "$@"'';
            };
    in
        with pkgs; [
            # lsp
            marksman
            docker-compose-language-service
            dockerfile-language-server
            vscode-langservers-extracted
            intelephense
            typescript-go
            sqls
            stylelint-language-server
            # formatter
            sqruff
        ];

    flake.modules.hjem.desktop = {pkgs, ...}: {
        packages = [
            (pkgs.stdenvNoCC.mkDerivation rec {
                pname = "mago";
                version = "1.30.0";
                src = pkgs.fetchurl {
                    url = "https://github.com/carthage-software/mago/releases/download/${version}/mago-${version}-x86_64-unknown-linux-musl.tar.gz";
                    hash = "sha256-u/UkBh6GhMTgzVwiBugGkvZsxXe6OotsRHDpEgNgxjw=";
                };
                installPhase = ''
                    runHook preInstall
                    install -Dm755 mago "$out/bin/mago"
                    runHook postInstall
                '';
            })
            inputs.phpantom-lsp.packages.${pkgs.stdenvNoCC.system}.phpantom-lsp
        ];
    };

}
