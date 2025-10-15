{
    pkgs,
    username,
    homeDirectory,
    inputs,
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
        systemPackages = import ../../modules/packages.nix {inherit pkgs;};
        variables = let
            myNeovim = inputs.self.neovim.packages.${pkgs.system}.nvim;
        in {
            EDITOR = "nvim";
            XDEBUG_MODE = "off";
            RAINFROG_CONFIG = "${homeDirectory}/.config/rainfrog";
            NIXCATS_VIM_PACK_DIR = "${inputs.self.neovim.packages.${pkgs.system}.nvim}";
        };
    };
}
