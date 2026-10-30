{
    flake.modules.nixos.core = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            curl
            dux-gop
            eza
            fastfetch
            fd
            jq
            ouch-rar
            ripgrep
            tree
            wget
        ];
    };
}
