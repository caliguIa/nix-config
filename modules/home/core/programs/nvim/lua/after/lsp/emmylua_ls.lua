---@type vim.lsp.Config
return {
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
        Lua = {
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
            codeLens = { enable = true },
            doc = { syntax = 'md' },
            hint = {
                enable = true,
                paramHint = true,
                indexHint = true,
                localHint = true,
                overrideHint = true,
                metaCallHint = true,
            },
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
                library = vim.list_extend(
                    { vim.env.VIMRUNTIME },
                    vim.tbl_filter(function(p)
                        local lua_dir = p .. '/lua'
                        return vim.uv.fs_stat(lua_dir) ~= nil
                    end, vim.api.nvim_list_runtime_paths())
                ),
            },
        },
    },
}
