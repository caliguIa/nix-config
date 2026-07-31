{
    flake.modules.nixos.core = {
        pkgs,
        lib,
        ...
    }: let
        version = "1.11.2";
        sources = {
            "x86_64-linux" = {
                url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-x86_64-unknown-linux-gnu.tar.gz";
                hash = "sha256-9cW/xUA9p0LEYI3/j4MGPVZvcyJpV1JYKYBuHur4sTM=";
            };
            "aarch64-linux" = {
                url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-aarch64-unknown-linux-gnu.tar.gz";
                hash = "sha256-zg141Dp+jHwAqzoaCNvOoC7ZFeAX+cO8HZF5W7wz1Qs=";
            };
        };
        source =
            sources.${pkgs.stdenv.hostPlatform.system}
            or (throw "elio: unsupported platform ${pkgs.stdenv.hostPlatform.system}");

        elio = pkgs.stdenv.mkDerivation {
            pname = "elio";
            inherit version;

            src = pkgs.fetchurl {inherit (source) url hash;};

            nativeBuildInputs = [pkgs.autoPatchelfHook];

            buildInputs = [pkgs.stdenv.cc.cc.lib];

            installPhase = ''
                runHook preInstall

                install -Dm755 elio -t $out/bin

                for size in 48 128 256 512; do
                    install -Dm644 \
                        "packaging/linux/icons/hicolor/''${size}x''${size}/apps/elio.png" \
                        "$out/share/icons/hicolor/''${size}x''${size}/apps/elio.png"
                done
                install -Dm644 packaging/linux/elio.desktop -t $out/share/applications

                runHook postInstall
            '';

            meta = {
                description = "Terminal file manager";
                homepage = "https://github.com/elio-fm/elio";
                license = pkgs.lib.licenses.mit;
                mainProgram = "elio";
                platforms = builtins.attrNames sources;
                sourceProvenance = [pkgs.lib.sourceTypes.binaryNativeCode];
            };
        };
        bin = lib.getExe elio;

        shellFuncBody = ''
            switch "$argv[1]"
                case shell '-*'
                    '${bin}' $argv
                    return $status
            end

            for arg in $argv
                switch "$arg"
                    case --chooser-file '--chooser-file=*'
                        '${bin}' $argv
                        return $status
                end
            end

            set -l tmp (mktemp -t "elio-cwd.XXXXXX")
            or return

            '${bin}' --cwd-file "$tmp" $argv
            set -l status_code $status

            if test -s "$tmp"
                set -l cwd (string collect < "$tmp")
                rm -f "$tmp"
                if test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
                    cd "$cwd"; or return $status
                end
            else
                rm -f "$tmp"
            end

            return $status_code
        '';
    in {
        environment.systemPackages = [elio];

        programs.fish.interactiveShellInit = ''
            function elio
                ${shellFuncBody}
            end

            function e
                ${shellFuncBody}
            end
        '';
    };
}
