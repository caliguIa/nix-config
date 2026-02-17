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
    in {
        devShells.default = pkgs.mkShellNoCC {
            packages = [update pin rebuild];
        };
    };
}
