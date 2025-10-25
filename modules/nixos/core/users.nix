let
    username = "caligula";
in {
    flake.modules.darwin.users = {
        system.primaryUser = username;
        users.users.${username} = {
            name = username;
            home = "/Users/${username}";
        };
    };

    flake.modules.nixos.users = {
        users.users.root = {
            isSystemUser = true;
            hashedPassword = "$y$j9T$I8oufKMTx8Jflidr4f4.b0$Ol.viqsLfnQLx/ZoBpviLui6jgB7Q5bPvJyJF.VzRoB";
        };
        users.users.${username} = {
            isNormalUser = true;
            extraGroups = ["wheel" "networkmanager"];
            group = username;
            hashedPassword = "$y$j9T$Zede9JU5rZt3ZQG9TLhBH0$C3byw1C5iPYSxPNrfrNM26Uws9aUjBpDAad0bjyd4D.";
        };
    };
}
