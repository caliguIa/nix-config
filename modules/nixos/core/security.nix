{
    flake.modules.nixos.core = {
        security.sudo = {
            enable = true;
            extraConfig = ''
                Defaults    timestamp_timeout=30
            '';
        };
    };
}
