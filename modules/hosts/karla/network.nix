{
    flake.modules.nixos.host_karla = {
        networking.hostName = "karla";
        programs.localsend.openFirewall = true;
    };
}
