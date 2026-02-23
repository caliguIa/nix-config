local get_lua_plugin_dirs = function()
    local expanded = vim.fs.normalize('$XDG_DATA_HOME/nvim/site/pack/core/opt')

    return vim.iter(vim.fs.dir(expanded))
        :filter(
            function(name, type) return type == 'directory' and vim.uv.fs_stat(expanded .. '/' .. name .. '/lua') ~= nil end
        )
        :map(function(name) return expanded .. '/' .. name end)
        :totable()
end

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
            codeAction = { insertSpace = false },
            codeLens = { enable = true },
            doc = { syntax = 'md' },
            documentColor = { enable = true },
            hover = { enable = true },
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
                    get_lua_plugin_dirs('$XDG_DATA_HOME/nvim/site/pack/core/opt')
                ),
            },
        },
    },
}
