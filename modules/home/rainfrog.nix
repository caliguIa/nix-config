{
    flake.modules.darwin.rainfrog = {pkgs, ...}: {
        environment.systemPackages = [pkgs.rainfrog];
    };
    flake.modules.homeManager.rainfrog = {
        xdg.configFile."rainfrog/rainfrog_config.toml".text = ''
            [db]
            ous-LOCAL = { host = "127.0.0.3", driver = "mysql", port = 3306, database = "oneupsales", username = "oneupsales" }
        '';
    };
}
