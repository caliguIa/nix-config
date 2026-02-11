{
    flake.modules.nixos.core = {
        systemd.tmpfiles.rules = ["d /data 0755 root root -"];
    };
}
