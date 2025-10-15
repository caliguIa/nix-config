{
    inputs,
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
        systemPackages = [
            inputs.self.outputs.neovim.packages.${pkgs.system}.nvim
            pkgs.bat
            pkgs.bottom
            pkgs.curl
            pkgs.eza
            pkgs.fd
            pkgs.fish
            pkgs.gitu
            pkgs.gnupg
            pkgs.gh
            pkgs.gh-dash
            pkgs.htop
            pkgs.jq
            pkgs.just
            pkgs.nix-output-monitor
            pkgs.prr
            pkgs.ripgrep
            pkgs.tree
            pkgs.yazi
            pkgs.wget
        ];
        variables = {
            EDITOR = "nvim";
            XDEBUG_MODE = "off";
            RAINFROG_CONFIG = "${homeDirectory}/.config/rainfrog";
        };
    };
}
