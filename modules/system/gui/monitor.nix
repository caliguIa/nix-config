{ user, ... }: {
    flake.modules.nixos.gui =
        { pkgs, ... }:
        {
            # DDC/CI rides the I2C bus embedded in the display cable - the same wires
            # the monitor uses to report its EDID. i2c-dev exposes those buses as
            # /dev/i2c-*, which is what Powerdevil needs to drive the real backlight.
            # Without it KWin reports detectedDdcCi=false and the brightness slider
            # falls back to crushing signal levels instead of dimming the panel.
            hardware.i2c.enable = true;
            users.users.${user.primary}.extraGroups = [ "i2c" ];

            # ddcutil detect / getvcp 10 - verifies the bus actually reaches the
            # monitor. DDC/CI over nvidia is flakier than over amdgpu/i915, and the
            # Ryzen iGPU registers buses of its own, so confirm before trusting it.
            environment.systemPackages = [ pkgs.ddcutil ];
        };
}
