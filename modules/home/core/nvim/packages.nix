{
    flake.modules.homeManager.core = {pkgs, ...}: {
        programs.neovim.extraPackages = with pkgs; [
            # lsp
            emmylua-ls
            nixd
            taplo
            bash-language-server
            # formatter
            alejandra
            stylua
        ];
        home.packages = with pkgs; [
            tree-sitter
            gcc
        ];
    };
}
