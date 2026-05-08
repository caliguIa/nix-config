{
    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            fish
            brush
            bottom
            broot
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
            gitu
            unzip
        ];
    };
}
