---@type vim.lsp.Config
return {
    on_attach = function(client)
        local caps = client.server_capabilities
        caps.hoverProvider = false
        caps.completionProvider = false
        caps.definitionProvider = true
        caps.declarationProvider = false
        caps.implementationProvider = false
        caps.referencesProvider = false
        caps.renameProvider = false
        caps.codeActionProvider = true
        caps.signatureHelpProvider = false
        caps.documentHighlightProvider = false

        -- symbols / navegation
        caps.documentSymbolProvider = false
        caps.workspaceSymbolProvider = false

        -- format / tokens
        caps.documentFormattingProvider = false
        caps.documentRangeFormattingProvider = false
        caps.semanticTokensProvider = nil

        -- other
        caps.typeDefinitionProvider = false
        caps.callHierarchyProvider = false
        caps.selectionRangeProvider = false
        caps.inlayHintProvider = false
    end,
    settings = {
        complete_function_calls = true,
        vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
                maxInlayHintLength = 30,
                completion = {
                    enableServerSideFuzzyMatch = true,
                    entriesLimit = 20,
                },
            },
        },
        typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true },
            },
        },
    },
}
