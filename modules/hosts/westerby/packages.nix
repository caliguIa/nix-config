{
    flake.modules.nixos.host_westerby = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
            mesa-demos
            vulkan-tools
        ];
    };
}
