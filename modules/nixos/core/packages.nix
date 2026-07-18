{
    flake.modules.nixos.core = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            bottom
            curl
            difftastic
            eza
            fd
            fzf
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
