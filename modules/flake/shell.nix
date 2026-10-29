{
    perSystem =
        { pkgs, ... }:
        let
            update = pkgs.writeShellApplication {
                name = "update";
                runtimeInputs = [ pkgs.git ];
                text = ''
                    cd "$(git rev-parse --show-toplevel)"
                    echo "=> Updating flake inputs"
                    nix flake update "$@"
                '';
            };

            pin = pkgs.writeShellApplication {
                name = "pin";
                runtimeInputs = [ pkgs.git ];
                text = ''
                    cd "$(git rev-parse --show-toplevel)"
                    if git diff --quiet HEAD -- flake.lock; then
                        echo "=> flake.lock unchanged, nothing to pin"
                        exit 0
                    fi
                    if ! git symbolic-ref -q HEAD >/dev/null || ! git rev-parse --verify -q '@{u}' >/dev/null; then
                        echo "=> not on a branch with an upstream, refusing to pin"
                        exit 1
                    fi
                    if [ "$(git rev-list --count '@{u}..HEAD')" -ne 0 ]; then
                        echo "=> unpushed commits on this branch, push them first"
                        exit 1
                    fi
                    echo "=> pinning flake.lock"
                    git commit --only flake.lock -m "flake.lock: Update"
                    git push
                '';
            };

            rb = pkgs.writeShellApplication {
                name = "rb";
                runtimeInputs = [
                    pkgs.git
                    pkgs.nh
                ];
                text = ''
                    cd "$(git rev-parse --show-toplevel)"
                    action="''${1:-switch}"
                    case "$action" in
                        switch | boot | test | build) ;;
                        *)
                            echo "Usage: rb [switch|boot|test|build] [extra nh args...]"
                            exit 1
                            ;;
                    esac
                    if [ "$#" -gt 0 ]; then
                        shift
                    fi
                    git add --intent-to-add --ignore-removal .
                    nh os "$action" . "$@"
                '';
            };

            zmk = pkgs.writeShellApplication {
                name = "zmk";
                text = ''
                    case "''${1:-}" in
                        build)
                            echo "=> Building ZMK firmware (.#zmk-firmware)"
                            out=$(nix build --no-link --print-out-paths .#zmk-firmware)
                            echo ""
                            echo "=> Firmware built. .uf2 files:"
                            ls -1 "$out"
                            echo ""
                            echo "Path: $out"
                            echo ""
                            echo "Flash with: zmk flash"
                            ;;
                        flash)
                            shift
                            exec nix run .#zmk-flash -- "$@"
                            ;;
                        *)
                            echo "Usage: zmk <command>"
                            echo ""
                            echo "Commands:"
                            echo "  build          Build the Lily58 firmware"
                            echo "  flash [part]   Flash firmware (optionally a single part: left|right)"
                            exit 1
                            ;;
                    esac
                '';
            };

            deploy = pkgs.writeShellApplication {
                name = "deploy";
                runtimeInputs = [
                    pkgs.git
                    pkgs.hostname
                    pkgs.jq
                    pkgs.nh
                ];
                text = ''
                    cd "$(git rev-parse --show-toplevel)"
                    host="''${1:-}"
                    action="''${2:-switch}"
                    shift "$(($# < 2 ? $# : 2))"

                    case "$action" in
                        switch | boot | test) ;;
                        *)
                            host=""
                            ;;
                    esac

                    if [ -z "$host" ]; then
                        echo "Usage: deploy <host> [switch|boot|test] [extra nh args...]"
                        exit 1
                    fi

                    hosts=$(nix eval --json .#nixosConfigurations --apply builtins.attrNames)
                    if ! jq -e --arg h "$host" 'any(.[]; . == $h)' <<<"$hosts" >/dev/null; then
                        echo "Unknown host: $host"
                        echo "Known hosts: $(jq -r 'join(", ")' <<<"$hosts")"
                        exit 1
                    fi

                    if [ "$host" = "$(hostname)" ]; then
                        echo "Refusing to deploy to the local host ($host); use rb instead"
                        exit 1
                    fi

                    echo "=> Deploying .#$host ($action) to root@$host"
                    git add --intent-to-add --ignore-removal .
                    nh os "$action" ".#$host" \
                        --target-host "root@$host" \
                        --build-host localhost \
                        "$@"
                '';
            };

            drvs = pkgs.writeShellApplication {
                name = "drvs";
                runtimeInputs = [ pkgs.git ];
                text = ''
                    cd "$(git rev-parse --show-toplevel)"
                    if [ "$#" -gt 1 ]; then
                        echo "Usage: drvs [rev]"
                        exit 1
                    fi
                    rev="$(git rev-parse "''${1:-HEAD}")"
                    git add --intent-to-add --ignore-removal .
                    # westerby is excluded: it does not evaluate
                    for host in karla tarr smiley; do
                        attr="nixosConfigurations.$host.config.system.build.toplevel.drvPath"
                        old=$(nix eval --raw "git+file://$PWD?rev=$rev#$attr")
                        new=$(nix eval --raw ".#$attr")
                        if [ "$old" = "$new" ]; then
                            echo "$host: same"
                        else
                            echo "$host: CHANGED"
                        fi
                    done
                '';
            };

            cdiff = pkgs.writeShellApplication {
                name = "cdiff";
                runtimeInputs = [
                    pkgs.git
                    pkgs.nvd
                ];
                text = ''
                    cd "$(git rev-parse --show-toplevel)"
                    host="''${1:-}"
                    if [ -z "$host" ]; then
                        echo "Usage: cdiff <host> [rev]"
                        exit 1
                    fi
                    rev="$(git rev-parse "''${2:-HEAD}")"
                    git add --intent-to-add --ignore-removal .
                    attr="nixosConfigurations.$host.config.system.build.toplevel"
                    echo "=> Building $host at $rev"
                    old=$(nix build --no-link --print-out-paths "git+file://$PWD?rev=$rev#$attr")
                    echo "=> Building $host in working tree"
                    new=$(nix build --no-link --print-out-paths ".#$attr")
                    nvd diff "$old" "$new"
                    nix store diff-closures "$old" "$new"
                '';
            };
        in
        {
            formatter = pkgs.nixfmt-tree.override {
                settings.formatter.nixfmt.options = [ "--indent=4" ];
            };
            devShells.default = pkgs.mkShellNoCC {
                packages = [
                    update
                    pin
                    rb
                    deploy
                    zmk
                    drvs
                    cdiff
                    pkgs.nvd
                ];
            };
        };
}
