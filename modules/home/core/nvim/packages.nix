{
    flake.modules.homeManager.core = {
        pkgs,
        config,
        ...
    }: {
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
            # biome
        ];
        home.sessionVariables = {
            INTELEPHENSE_KEY_PATH = config.age.secrets.intelephense.path;
        };
    };
}
