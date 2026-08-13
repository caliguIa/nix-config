{
    perSystem =
        { pkgs, ... }:
        let
            update = pkgs.writeShellScriptBin "update" ''
                echo "=> Updating flake inputs"
                nix flake update
            '';

            pin = pkgs.writeShellScriptBin "pin" ''
                echo "=> pinning flake.lock"
                git add flake.lock
                git commit -m "flake.lock: Update"
                git push
            '';

            rb = pkgs.writeShellScriptBin "rb" ''
                git add .
                case "''${1:-switch}" in
                    switch)
                        nh os switch .
                        ;;
                    boot)
                        nh os boot .
                        ;;
                    *)
                        echo "Usage: rb [switch|boot]"
                        exit 1
                        ;;
                esac
            '';

            zmk = pkgs.writeShellScriptBin "zmk" ''
                set -euo pipefail
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

            deploy = pkgs.writeShellScriptBin "deploy" ''
                _deploy() {
                    local hostname="$1"
                    echo "=> Deploying .#$hostname to root@$hostname"
                    git add .
                    nh os switch .#$hostname \
                        --target-host "root@$hostname" \
                        --build-host localhost
                }

                case "''${1:-}" in
                    smiley)
                        _deploy "smiley"
                        ;;
                    *)
                        echo "Usage: deploy <target>"
                        echo ""
                        echo "Targets:"
                        echo "  smiley    Deploy to smiley (root@smiley)"
                        exit 1
                        ;;
                esac
            '';
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
                ];
            };
        };
}
