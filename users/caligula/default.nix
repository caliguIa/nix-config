{
    pkgs,
    username,
    homeDirectory,
    ...
}: {
    users = {
        users.${username} = {
            # isNormalUser = true;
            home = homeDirectory;
            shell = pkgs.fish;
            # extraGroups = ["wheel" "networkmanager" "docker" "share"];
        };
    };
    programs.fish.enable = true;

    environment = {
        shells = [pkgs.fish];
        systemPackages = import ../../modules/common/packages.nix {inherit pkgs;};
        systemPath = [
            "${homeDirectory}/.cargo/bin"
            "${homeDirectory}/.local/bin"
            "${homeDirectory}/go/bin"
        ];
        variables = {
            EDITOR = "nvim";
        };
    };
}
