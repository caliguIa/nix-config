{
    flake.modules.nixos.core = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            bottom
            curl
            difftastic
            eza
            fastfetch
            fd
            fzf
            gnumake
            gnupg
            hurl
            jq
            just
            lazydocker
            lazygit
            ouch
            prr
            ripgrep
            tree
            unzip
            wget
        ];
    };
}
