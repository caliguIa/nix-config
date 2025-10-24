let
    sudoTimeout = "Defaults    timestamp_timeout=30";
in {
    flake.modules.darwin.security = {
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

    flake.modules.nixos.security = {
        security.sudo = {
            enable = true;
            extraConfig = ''
                ${sudoTimeout}
            '';
        };
    };
}
