local pluginSources = function()
    return vim.iter(vim.tbl_values(require('nixCats').pawsible.allPlugins.start))
        :map(function(path) return path .. '/lua' end)
        :totable()
end
print(pluginSources()[1])

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
            codeLens = {
                enable = true,
            },
            diagnostics = {
                globals = {
                    'nixCats',
                    'MiniStatusline',
                    'MiniExtra',
                    'MiniBufremove',
                    'MiniCompletion',
                    'MiniDiff',
                    'MiniMisc',
                    'MiniIcons',
                    'MiniPick',
                    'Zendiagram',
                },
                disable = {
                    'unnecessary-if', -- buggy rule
                },
            },
            doc = {
                syntax = 'md',
            },
            hint = {
                enable = true,
                paramHint = true,
                indexHint = true,
                localHint = true,
                overrideHint = true,
                metaCallHint = true,
            },
            inlineValues = {
                enable = true,
            },
            runtime = {
                version = 'LuaJIT',
                requirePattern = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                    '?/lua/?.lua',
                    '?/lua/?/init.lua',
                },
            },
            semanticTokens = {
                enable = true,
            },
            signature = {
                detailSignatureHelper = true,
            },
            strict = {
                requirePath = true,
                typeCall = true,
                arrayIndex = true,
                metaOverrideFileDefine = true,
                docBaseConstMatchBaseType = true,
            },
            workspace = {
                library = vim.list_extend({
                    '$VIMRUNTIME',
                    require('nixCats').nixCatsPath .. '/lua',
                }, pluginSources()),
                ignoreGlobs = { '**/*_spec.lua' },
            },
        },
    },
}
