{
    pkgs,
    username,
    homeDirectory,
    ...
}: {
    users = {
        users.${username} = {
            home = homeDirectory;
            shell = pkgs.fish;
        };
    };
    programs.fish.enable = true;
    environment = {
        shells = [pkgs.fish];
        systemPackages = import ../../modules/common/packages.nix {inherit pkgs;};
        variables = {
            EDITOR = "nvim";
        };
    };
}
