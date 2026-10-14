{
    flake.modules.nixos.gui =
        { pkgs, ... }:
        let
            script = pkgs.writeShellApplication {
                name = "artisan";
                runtimeInputs = [
                    pkgs.coreutils
                    pkgs.jq
                    pkgs.git
                ];
                text = builtins.readFile ./artisan.sh;
            };

            artisan = pkgs.symlinkJoin {
                name = "artisan";
                paths = [ script ];
                nativeBuildInputs = [ pkgs.installShellFiles ];
                postBuild = ''
                    installShellCompletion --cmd artisan \
                        --bash ${./artisan.bash} \
                        --fish ${./artisan.fish}
                '';
                meta.mainProgram = "artisan";
            };
        in
        {
            environment.systemPackages = [ artisan ];
        };
}
