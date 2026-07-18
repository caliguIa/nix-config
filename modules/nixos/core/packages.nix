{
    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            bat
            bottom
            curl
            difftastic
            eza
            fd
            gitu
            gnumake
            gnupg
            hurl
            jq
            just
            lazydocker
            ouch
            prr
            ripgrep
            tree
            unzip
            wget
        ];
    };
}
