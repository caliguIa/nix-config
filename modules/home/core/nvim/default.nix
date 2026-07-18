{inputs, ...}: {
    flake.modules.hjem.core = {
        config,
        pkgs,
        lib,
        ...
    }: let
        inherit (lib.meta) getExe;
        inherit (lib.strings) makeBinPath;

        stylelint-language-server = pkgs.writeShellApplication {
            name = "stylelint-language-server";
            runtimeInputs = [pkgs.nodejs];
            text = let
                ext = pkgs.vscode-extensions.stylelint.vscode-stylelint;
            in ''exec node ${ext}/share/vscode/extensions/stylelint.vscode-stylelint/dist/start-server.js "$@"'';
        };

        mago = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
            pname = "mago";
            version = "1.30.0";
            src = pkgs.fetchurl {
                url = "https://github.com/carthage-software/mago/releases/download/${finalAttrs.version}/mago-${finalAttrs.version}-x86_64-unknown-linux-musl.tar.gz";
                hash = "sha256-u/UkBh6GhMTgzVwiBugGkvZsxXe6OotsRHDpEgNgxjw=";
            };
            installPhase = ''
                runHook preInstall
                install -Dm755 mago "$out/bin/mago"
                runHook postInstall
            '';
        });

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
            typescript-go
            sqls
            stylelint-language-server
            inputs.phpantom-lsp.packages.${pkgs.stdenvNoCC.system}.phpantom-lsp
            # formatter
            alejandra
            stylua
            sqruff
        ];

        neovim = pkgs.wrapNeovimUnstable inputs.nvim-nightly.packages.${pkgs.stdenvNoCC.system}.neovim {
            withNodeJs = false;
            withPython3 = false;
            withRuby = false;
            wrapRc = false;
            wrapperArgs = ["--suffix" "PATH" ":" (makeBinPath tools)];
        };

        aliases = pkgs.runCommand "nvim-aliases" {} ''
            mkdir -p $out/bin
            ln -s ${getExe neovim} $out/bin/vi
            ln -s ${getExe neovim} $out/bin/vim
            cat > $out/bin/vimdiff <<EOF
            #!${pkgs.runtimeShell}
            exec ${getExe neovim} -d "\$@"
            EOF
            chmod +x $out/bin/vimdiff
        '';
    in {
        packages = [
            neovim
            aliases
            mago
            pkgs.tree-sitter
            pkgs.gcc
        ];
        files = {
            ".config/nvim/init.lua".source = ./lua/init.lua;
            ".config/nvim/after".source = ./lua/after;
            ".config/nvim/plugin".source = ./lua/plugin;
        };
    };
}
