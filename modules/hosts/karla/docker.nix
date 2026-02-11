{
    flake.modules.nixos.host_karla = {
        virtualisation.docker = {
            enable = true;
            storageDriver = "overlay2";
            daemon.settings = {
                dns = ["1.1.1.1" "8.8.8.8"];
                log-driver = "journald";
                storage-driver = "overlay2";
                # registry-mirrors = ["https://mirror.gcr.io"];
            };
        };
    };
}
