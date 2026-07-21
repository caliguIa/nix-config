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
                local remote="$2"
                echo "=> Deploying .#$hostname to $remote"
                git add .
                nixos-rebuild switch \
                    --flake ".#$hostname" \
                    --target-host "$remote" \
                    --build-host localhost
            }

            case "''${1:-}" in
                smiley)
                    _deploy "smiley" "''${2:-root@smiley}"
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
