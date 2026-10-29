{
    flake.modules.nixos.host_tarr = {
        networking.hostName = "tarr";
        programs.steam.remotePlay.openFirewall = true;
        programs.localsend.openFirewall = true;
    };
}
