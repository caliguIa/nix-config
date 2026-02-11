{
    flake.modules.nixos.host_karla = {pkgs, ...}: {
        hardware.graphics.enable = true;
        services.xserver.videoDrivers = ["amdgpu"];
        programs.steam.enable = true;
        programs.steam.gamescopeSession.enable = true;
        programs.gamemode.enable = true;
        environment.systemPackages = with pkgs; [mangohud protonup-qt bottles];
    };
}
