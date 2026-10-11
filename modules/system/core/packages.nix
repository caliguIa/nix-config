{
    flake.modules.nixos.core = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            bottom
            curl
            eza
            fastfetch
            fd
            fzf
            gnumake
            gnupg
            jq
            lazydocker
            lazygit
            ouch-rar
            ripgrep
            tree
            wget
        ];
    };
}
