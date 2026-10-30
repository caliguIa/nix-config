# Named laravel-artisan: nixpkgs' `artisan` is an unrelated coffee-roasting app.
{
    writeShellApplication,
    symlinkJoin,
    installShellFiles,
    coreutils,
    jq,
    git,
}:
let
    script = writeShellApplication {
        name = "artisan";
        runtimeInputs = [
            coreutils
            jq
            git
        ];
        text = builtins.readFile ./artisan.sh;
    };
in
symlinkJoin {
    name = "artisan";
    paths = [ script ];
    nativeBuildInputs = [ installShellFiles ];
    postBuild = ''
        installShellCompletion --cmd artisan \
            --bash ${./artisan.bash} \
            --fish ${./artisan.fish}
    '';
    meta.mainProgram = "artisan";
}
