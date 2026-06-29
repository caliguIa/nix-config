---@type vim.lsp.Config
return {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.emmyrc.json') or vim.uv.fs_stat(path .. '/.luarc.json'))
            then
                client.config.settings = {}
            end
        end
    end,
    settings = {
        emmylua = {
            diagnostics = { globals = { 'vim' } },
            completion = {
                enable = true,
                autoRequire = true,
                autoRequireFunction = 'require',
                autoRequireNamingConvention = 'keep',
                autoRequireSeparator = '.',
                callSnippet = false,
                postfix = '@',
                baseFunctionIncludesName = true,
            },
            codeAction = { insertSpace = false },
            codeLens = { enable = true },
            doc = { syntax = 'md' },
            documentColor = { enable = true },
            hover = { enable = true },
            hint = { enable = true },
            inlineValues = { enable = true },
            runtime = {
                version = 'LuaJIT',
                requirePattern = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                    '?/lua/?.lua',
                    '?/lua/?/init.lua',
                },
            },
            semanticTokens = { enable = true },
            signature = { detailSignatureHelper = true },
            strict = {
                requirePath = true,
                typeCall = true,
                arrayIndex = true,
                metaOverrideFileDefine = true,
                docBaseConstMatchBaseType = true,
            },
            workspace = {
                ignoreSubmodules = true,
                ignoreGlobs = { '**/*_spec.lua' },
                library = vim.api.nvim_get_runtime_file('', true),
            },
        },
    },
}
