{
    # Data-shaped ftplugins: vim.opt_local settings -> after/ftplugin/<ft>.lua.
    # Logic-heavy ones (markdown, sql, sqls_output) live in extra-files.nix.
    flake.modules.hjem.nvim-module = {
        programs.nvim-module.ftplugins = {
            css.settings = {
                tabstop = 2;
                shiftwidth = 2;
            };
            json.settings = {
                tabstop = 2;
                conceallevel = 0;
            };
            jsonc.settings = {
                tabstop = 2;
                conceallevel = 0;
            };
            php.settings = {
                commentstring = "//%s";
                spell = true;
            };
            javascript.settings.spell = true;
            javascriptreact.settings.spell = true;
            typescript.settings.spell = true;
            typescriptreact.settings.spell = true;
        };
    };
}
