{
    flake.modules.hjem.core = {pkgs, ...}: {
        packages = [pkgs.fzf];
    };
}
