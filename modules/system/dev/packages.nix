{
    flake.modules.nixos.dev =
        { pkgs, ... }:
        {
            environment.systemPackages = with pkgs; [
                gnumake
                gnupg
                lazydocker
            ];
        };
}
