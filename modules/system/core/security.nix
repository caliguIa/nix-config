{
    flake.modules.nixos.core = {
        security.sudo.enable = false;
        security.sudo-rs = {
            enable = true;
            extraConfig = "Defaults    timestamp_timeout=30";
        };
    };
}
