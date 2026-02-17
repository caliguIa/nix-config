{config, ...}: let
    username = config.flake.meta.users.primary;
in {
    flake.modules.nixos.core = {
        users.users.${username} = {
            name = username;
            home = "/home/${username}";
            isNormalUser = true;
            extraGroups = ["wheel" "networkmanager"];
            group = username;
            hashedPassword = "$y$j9T$Zede9JU5rZt3ZQG9TLhBH0$C3byw1C5iPYSxPNrfrNM26Uws9aUjBpDAad0bjyd4D.";
        };
        users.users.root = {
            isSystemUser = true;
            hashedPassword = "$y$j9T$I8oufKMTx8Jflidr4f4.b0$Ol.viqsLfnQLx/ZoBpviLui6jgB7Q5bPvJyJF.VzRoB";
        };
    };
}
