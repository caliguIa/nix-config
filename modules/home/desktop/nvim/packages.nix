{inputs, ...}: {
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        ...
    }: {
        programs.neovim.extraPackages = with pkgs; [
            # lsp
            marksman
            vscode-langservers-extracted
            docker-compose-language-service
            dockerfile-language-server
            intelephense
            typescript-go
            sqls
            # formatter
            sqruff
        ];
        home.packages = [
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
        home.sessionVariables = {
            INTELEPHENSE_KEY_PATH = config.age.secrets.intelephense.path;
        };
    };
}
