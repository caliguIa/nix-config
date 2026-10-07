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
            lazydocker
            lazygit
            ouch-rar
            ripgrep
            tree
            unzip
            wget
        ];
    };
}
