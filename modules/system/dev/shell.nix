{
    # Shortcuts for dev-only tools (docker, gh, Neogit), kept out of core so
    # smiley doesn't get commands that can't run there.
    flake.modules.nixos.dev.programs.fish = {
        shellAliases = {
            dcua = "docker compose up";
            dash = "gh dash";
        };
        shellAbbrs = {
            dps = "docker ps";
            dcu = "docker compose up";
            dce = "docker compose exec";
            gg = "nvim -c Neogit";
        };
    };
}
