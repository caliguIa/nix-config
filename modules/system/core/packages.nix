{
    flake.modules.nixos.core = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            curl
            dux-gop
            eza
            fastfetch
            fd
            fzf
            jq
            lazygit
            ouch-rar
            ripgrep
            tree
            wget
        ];
    };
}
