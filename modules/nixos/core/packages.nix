{
    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            bottom
            curl
            eza
            fd
            fish
            gnupg
            gh
            jq
            lazydocker
            just
            ouch
            ripgrep
            tree
            uutils-coreutils-noprefix
            wget
            prr
            hurl
        ];
    };
}
