{
    flake.modules.hjem.core =
        {
            pkgs,
            lib,
            ...
        }:
        let
            inherit (lib.strings) makeBinPath;

            inherit (import ../_editor-tools.nix { inherit pkgs; }) tools mago;

            # nixfmt with this repo's 4-space indent when formatting files inside ~/nix-config.
            # helix pipes the buffer on stdin and passes the file path as $1.
            nixfmt-dispatch = pkgs.writeShellApplication {
                name = "nixfmt-dispatch";
                runtimeInputs = [ pkgs.nixfmt ];
                text = ''
                    target="''${1:-$PWD}"
                    case "$(realpath -m "$target")" in
                        "$HOME/nix-config" | "$HOME/nix-config/"*) exec nixfmt --indent=4 ;;
                        *) exec nixfmt ;;
                    esac
                '';
            };

            # nixd with nixos/hjem option completion for this host, but only when
            # editing this flake (mirrors nvim/lua/after/lsp/nixd.lua). `--config`
            # takes the same JSON as the `nixd` settings section; helix starts the
            # server in the workspace root, so $PWD is what it keys off.
            nixd-dispatch = pkgs.writeShellApplication {
                name = "nixd-dispatch";
                runtimeInputs = [
                    pkgs.nixd
                    pkgs.jq
                    pkgs.coreutils
                ];
                text = ''
                    flake="$HOME/nix-config"
                    if [ "$(realpath -m "$PWD")" = "$(realpath -m "$flake")" ]; then
                        options="(builtins.getFlake \"$flake\").nixosConfigurations.\"$(uname -n)\".options"
                        config=$(jq -nc \
                            --arg nixos "$options" \
                            --arg hjem "$options.hjem.users.type.getSubOptions []" \
                            '{nixpkgs: {expr: "import <nixpkgs> { }"}, options: {nixos: {expr: $nixos}, hjem: {expr: $hjem}}}')
                    else
                        config='{"nixpkgs":{"expr":"import <nixpkgs> { }"}}'
                    fi
                    exec nixd --config="$config"
                '';
            };

            # typescript-go LSP, preferring a project-local tsgo (mirrors
            # nvim/lua/after/lsp/tsc.lua); nixpkgs' `typescript` (7.x) is the Go
            # port, so its `tsc --lsp` is the same server.
            tsgo-dispatch = pkgs.writeShellApplication {
                name = "tsgo-dispatch";
                runtimeInputs = [ pkgs.typescript ];
                text = ''
                    for bin in node_modules/.bin/tsgo tsgo; do
                        if command -v "$bin" >/dev/null 2>&1; then
                            exec "$bin" --lsp --stdio
                        fi
                    done
                    exec tsc --lsp --stdio
                '';
            };

            # nnn as a file picker for the `-` key (see config.toml).
            #   hx-nnn pick FILE  run nnn in FILE's directory; opening a file in nnn
            #                     (Enter; -o keeps `l` from xdg-opening it)
            #                     records it and quits. Prints nothing, since helix
            #                     runs this via :insert-output.
            #   hx-nnn path FILE  print the picked path, or FILE (if it exists) when
            #                     nothing was picked, so a cancel re-opens the buffer.
            hx-nnn = pkgs.writeShellApplication {
                name = "hx-nnn";
                runtimeInputs = [
                    (import ../_nnn.nix { inherit pkgs; })
                    pkgs.coreutils
                ];
                text = ''
                    pick="''${XDG_RUNTIME_DIR:-/tmp}/hx-nnn-pick"
                    case "$1" in
                        pick)
                            rm -f "$pick"
                            dir=$(dirname -- "$2")
                            [ -d "$dir" ] || dir=.
                            nnn -o -p "$pick" "$dir" </dev/tty >/dev/tty 2>&1 || true
                            # picker-mode nnn draws on stderr, so that needs the tty too.
                            # nnn leaves the alternate screen on exit; put helix's back.
                            printf '\033[?1049h\033[?2004h' >/dev/tty
                            ;;
                        path)
                            if [ -s "$pick" ]; then
                                head -n 1 "$pick"
                            elif [ -e "$2" ]; then
                                printf '%s\n' "$2"
                            fi
                            ;;
                    esac
                '';
            };

            helix = pkgs.symlinkJoin {
                name = "helix";
                paths = [ pkgs.helix ];
                nativeBuildInputs = [ pkgs.makeWrapper ];
                postBuild = ''
                    wrapProgram $out/bin/hx \
                        --suffix PATH : ${
                            makeBinPath (
                                tools
                                ++ [
                                    mago
                                    nixfmt-dispatch
                                    nixd-dispatch
                                    tsgo-dispatch
                                    hx-nnn
                                    # diagnostics-only TS server, see languages.toml
                                    pkgs.typescript-language-server
                                ]
                            )
                        }
                '';
            };
        in
        {
            packages = [ helix ];
            xdg.config.files = {
                "helix/config.toml".source = ./config.toml;
                "helix/languages.toml".source = ./languages.toml;
                "helix/themes/kanso-mist.toml".source = ./themes/kanso-mist.toml;
            };
        };
}
