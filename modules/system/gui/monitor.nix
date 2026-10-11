{ user, ... }: {
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            hardware.i2c.enable = true;
            users.users.${user.primary}.extraGroups = [ "i2c" ];
            environment.systemPackages = [ pkgs.ddcutil ];
        };
}
