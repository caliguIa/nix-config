{
    flake.modules.homeManager.core = {
        pkgs,
        config,
        ...
    }: {
        programs.neovim.extraPackages = with pkgs; [
            # lsp
            emmylua-ls
            marksman
            nixd
            taplo
            vscode-langservers-extracted
            bash-language-server
            typescript-go
            sqls
            # formatter
            alejandra
            sqruff
            stylua
        ];
        home.sessionVariables = {
            INTELEPHENSE_KEY_PATH = config.age.secrets.intelephense.path;
        };
    };
}
