---@type vim.lsp.Config
return {
    on_attach = function(client)
        local caps = client.server_capabilities
        caps.hoverProvider = true
        caps.completionProvider = true
        caps.definitionProvider = false
        caps.declarationProvider = true
        caps.implementationProvider = true
        caps.referencesProvider = true
        caps.renameProvider = true
        caps.codeActionProvider = false
        caps.signatureHelpProvider = true
        caps.documentHighlightProvider = true

        -- symbols / navegation
        caps.documentSymbolProvider = true
        caps.workspaceSymbolProvider = true

        -- format / tokens
        caps.documentFormattingProvider = true
        caps.documentRangeFormattingProvider = true
        caps.semanticTokensProvider = nil

        -- other
        caps.typeDefinitionProvider = true
        caps.callHierarchyProvider = true
        caps.selectionRangeProvider = true
        caps.inlayHintProvider = true
    end,
    settings = {
        complete_function_calls = true,
        typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = false },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
            },
        },
    },
}
