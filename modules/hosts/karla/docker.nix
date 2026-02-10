{
    flake.modules.nixos.host_karla = {
        virtualisation.docker = {
            enable = true;
            storageDriver = "overlay2";
            daemon.settings = {
                dns = ["1.1.1.1" "8.8.8.8"];
                log-driver = "journald";
                # registry-mirrors = ["https://mirror.gcr.io"];
                # storage-driver = "overlay2";
            };
            # Use the rootless mode - run Docker daemon as non-root user
            rootless = {
                enable = false;
                setSocketVariable = true;
            };
        };
    };
}
