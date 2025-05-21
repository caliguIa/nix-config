{
    services.sabnzbd = {
        enable = true;
        configFile = "/var/lib/sabnzbd/sabnzbd.ini";
        openFirewall = true;
        user = "share";
        group = "share";
    };
}

