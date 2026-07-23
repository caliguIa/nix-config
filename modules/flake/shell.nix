{
    perSystem = {pkgs, ...}: let
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

        rebuild = pkgs.writeShellScriptBin "rebuild" ''
            git add .
            nh os switch .
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
    in {
        devShells.default = pkgs.mkShellNoCC {
            packages = [update pin rebuild deploy];
        };
    };
}
