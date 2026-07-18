{
    flake.modules.hjem.core = {pkgs, ...}: let
        toml = pkgs.formats.toml {};
    in {
        packages = [pkgs.atuin];
        xdg.config.files."atuin/config.toml" = {
            generator = toml.generate "config.toml";
            value = {
                dialect = "uk";
                auto_sync = true;
                update_check = true;
                sync_frequency = "5m";
                sync_address = "https://api.atuin.sh";
            };
        };
    };
}
