let
    username = "caligula";
in {
    flake.modules.nixos.users = {
        users = {
            users = {
                ${username}.extraGroups = ["wheel" "networkmanager" "media"];
                media = {
                    isSystemUser = true;
                    group = "media";
                };
            };
            groups = {
                ${username} = {};
                media = {};
            };
        };
    };
}
