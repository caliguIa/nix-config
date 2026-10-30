{
    flake.modules.nixos.host_tarr = {
        programs.steam.remotePlay.openFirewall = true;
        programs.localsend.openFirewall = true;
    };
}
