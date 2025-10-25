let
    sudoTimeout = "Defaults    timestamp_timeout=30";
in {
    flake.modules.darwin.core = {
        security = {
            pam.services.sudo_local = {
                enable = true;
                touchIdAuth = true;
                reattach = true;
            };
            sudo.extraConfig = ''
                ${sudoTimeout}
            '';
        };
    };

    flake.modules.nixos.core = {
        security.sudo = {
            enable = true;
            extraConfig = ''
                ${sudoTimeout}
            '';
        };
    };
}
