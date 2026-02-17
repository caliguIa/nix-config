{
    flake.modules.homeManager.core = {pkgs, ...}: {
        programs.neovim.extraPackages = with pkgs; [
            emmylua-ls
            marksman
            nixd
            taplo
            just-lsp
            vscode-langservers-extracted
            nodePackages.bash-language-server
            alejandra
            lua-language-server
            # typescript-go
            sleek
            stylua
            sqruff
            vtsls
            biome
        ];
    };
}
