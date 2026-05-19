{
    flake.modules.nixos.desktop = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            # bluez
            # bluez-tools
            # gnome-bluetooth
            # gnome-control-center
        ];
        services.blueman.enable = false;
        # Regression in kernel causing bluetooth to stop working, below required until this issue is resolved
        # https://github.com/NixOS/nixpkgs/issues/521528
        boot.kernelPatches = [
            {
                name = "Bluetooth: btmtk: accept too short WMT FUNC_CTRL events";
                patch = pkgs.fetchurl {
                    url = "https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/patch/?id=162b1adeb057d28ad84fd8a03f3c50cf08db5c62";
                    hash = "sha256-ij0hQmC0U++AdXWQy6nycnDe6z4yaMoQIrSiLal5DHc=";
                };
            }
        ];
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
            package = pkgs.bluez;
            settings = {
                General = {
                    Experimental = true;
                    FastConnectable = false;
                };
                Policy = {
                    AutoEnable = true;
                };
            };
        };
    };
}
