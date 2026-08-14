{
    flake.modules.nixos.host_karla =
        { lib, ... }:
        {
        # Wake-from-suspend arming.
        #
        # This laptop only supports s2idle (`/sys/power/mem_sleep` = [s2idle]);
        # there is no deep S3 state. Under s2idle the USB controllers stay
        # powered enough to signal wakeup, so "suspend" can be woken by input
        # devices as long as every node in the wake path has power/wakeup armed.
        #
        # Existing rules in hardware.nix already arm the USB hubs (class 09) and
        # the Logitech receiver (046d:c52b, the USB mouse). The missing piece was
        # the internal Bluetooth controller, which the Bluetooth keyboard talks
        # through. Arm it here so keyboard input can wake the machine.
        services.udev.extraRules = ''
            # MediaTek Bluetooth/WiFi combo controller (hci0). bmAttributes bit5
            # is set, so it advertises remote-wakeup capability; it just needs to
            # be armed. This is the wake path for the Bluetooth keyboard.
            ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="e616", ATTR{power/wakeup}="enabled"
        '';

        # Help the controller re-page bonded HID peripherals quickly after
        # resume so a keypress reconnects and wakes the machine promptly.
        # The shared desktop module sets this to false, so force it here.
        hardware.bluetooth.settings.General.FastConnectable = lib.mkForce true;
    };
}
