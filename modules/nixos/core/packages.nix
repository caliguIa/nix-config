{
    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            fish
            bottom
            eza
            fd
            gnupg
            jq
            lazydocker
            just
            ouch
            ripgrep
            tree
            prr
            curl
            wget
            hurl
        ];
    };
}
