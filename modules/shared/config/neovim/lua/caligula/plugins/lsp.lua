local diagnostics_icons = require('caligula.core.icons').diagnostics

local jsLinters = {
    'eslint',
    'eslint_d',
}

local root_dir = function()
    return require('lspconfig.util').root_pattern '.eslintrc.json'(vim.api.nvim_buf_get_name(0))
    -- return require('lspconfig.util').find_git_ancestor(vim.fn.getcwd())
end

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            { 'j-hui/fidget.nvim', opts = {} },
            { 'folke/neodev.nvim' },
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        lazy = false,
        keys = {
            { [[<leader>lr]], [[:LspRestart<CR>]], mode = 'n', silent = true, desc = '[L]sp [r]estart' },
        },
        config = function()
            require('neodev').setup {
                override = function(root_dir, library)
                    if root_dir:find('/Users/caligula/nix-config', 1, true) == 1 then
                        library.enabled = true
                        library.plugins = true
                    end
                end,
                library = {
                    plugins = {
                        'neotest',
                        'nvim-treesitter',
                        'plenary.nvim',
                    },
                    types = true,
                },
            }

            local lspconfig = require 'lspconfig'
            local fzf_lua = require 'fzf-lua'

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    local bufnr = event.buf
                    local client = assert(vim.lsp.get_client_by_id(event.data.client_id), 'Must have valid client')

                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map(
                        'gd',
                        function() fzf_lua.lsp_definitions { jump_to_single_result = true } end,
                        '[G]oto [D]efinition'
                    )

                    map(
                        'gr',
                        function() fzf_lua.lsp_references { jump_to_single_result = true } end,
                        '[G]oto [R]eferences'
                    )

                    map('gt', function() fzf_lua.lsp_typedefs { jump_to_single_result = true } end, 'Type [D]efinition')

                    map('<leader>ds', fzf_lua.lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', fzf_lua.lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', fzf_lua.lsp_code_actions, '[C]ode [A]ction')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gD', fzf_lua.lsp_declarations, '[G]oto [D]eclaration')
                    map('<leader>e', vim.diagnostic.open_float, 'Show line diagnostics')
                    map(']d', vim.diagnostic.goto_next, 'Go to next diagnostic')
                    map('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic')

                    if client and client.name == 'eslint' and client.server_capabilities.document_formatting then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = bufnr,
                            command = 'EslintFixAll',
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' },
                            },
                            workspace = {
                                checkThirdParty = false,
                                telemetry = {
                                    enable = false,
                                },
                                -- library = {
                                --     [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                                --     [vim.fn.stdpath 'config' .. '/lua'] = true,
                                -- },
                            },
                        },
                    },
                },
                html = {},
                cssls = {},
                bashls = {},
                rust_analyzer = {},
                taplo = {},
                yamlls = {},
                jsonls = {},
                gopls = {},
                marksman = {},
                nil_ls = {},
                ocamllsp = {},
                reason_ls = {},
                eslint = {
                    settings = {
                        workingDirectories = { mode = 'auto' },
                    },
                    root_dir = lspconfig.util.root_pattern '.eslintrc.json',
                },
                -- phpactor = {
                --     filetypes = { 'php', 'blade' },
                -- init_options = {
                --     ['language_server.diagnostic_providers'] = {
                --         'missing_method',
                --         'assignment_to_missing_property',
                --         'missing_return_type',
                --         'unresolvable_name',
                --         'unused_import',
                --         'deprecated usage',
                --         'undefined_variable',
                --         -- 'docblock_missing_extends_tag',
                --         -- 'docblock_missing_implements_tag',
                --         -- 'docblock_missing_param',
                --         -- 'docblock_missing_return',
                --     },
                -- },
                --     root_dir = lspconfig.util.root_pattern 'composer.json',
                -- },
                intelephense = {
                    root_dir = lspconfig.util.root_pattern 'composer.json',
                    init_options = {
                        storagePath = '/tmp/intelephense',
                        globalStoragePath = os.getenv 'HOME' .. '/.cache/intelephense',
                        licenceKey = os.getenv 'HOME' .. '/.local/auth/intelephense.txt' or '',
                    },
                    diagnostics = {
                        undefinedTypes = false,
                    },
                    format = { enable = false },
                    commands = {
                        IntelephenseIndex = {
                            function() vim.lsp.buf.execute_command { command = 'intelephense.index.workspace' } end,
                        },
                    },
                    on_attach = function(client, bufnr)
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                        -- if client.server_capabilities.inlayHintProvider then
                        --   vim.lsp.buf.inlay_hint(bufnr, true)
                        -- end
                    end,
                },
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua',
                'prettierd',
                'prettier',
                'pint',
                'ocamlformat',
            })

            require('mason').setup { ui = { border = 'single' } }
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }
            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }

            local signs = {
                Error = diagnostics_icons.ERROR,
                Warn = diagnostics_icons.WARN,
                Hint = diagnostics_icons.HINT,
                Info = diagnostics_icons.INFO,
            }
            for type, icon in pairs(signs) do
                local hl = 'DiagnosticSign' .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
            end

            -- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
            --     vim.lsp.diagnostic.on_publish_diagnostics,
            --     { underline = true, virtual_text = false, signs = false, update_in_insert = false }
            -- )
            vim.diagnostic.config { virtual_text = false, signs = false, underline = true }

            require('lspconfig.ui.windows').default_options.border = 'single'
            -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
            -- vim.lsp.handlers['textDocument/signatureHelp'] =
            --     vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
        end,
    },

    {
        'pmizio/typescript-tools.nvim',
        ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {
            expose_as_code_action = 'all',
            jsx_close_tag = {
                enable = true,
                filetypes = { 'javascriptreact', 'typescriptreact' },
            },
            settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayVariableTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                },
            },
        },
    },

    {
        'dmmulroy/ts-error-translator.nvim',
        ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        opts = {},
    },

    {
        'dmmulroy/tsc.nvim',
        cmd = { 'TSC', 'TSCStop' },
        opts = {
            use_trouble_qflist = false,
            run_as_monorepo = false,
        },
        keys = {
            { '<leader>Ts', ':TSC<CR>', mode = 'n', silent = true, noremap = true, desc = '[T]SC [s]tart' },
            { '<leader>Tx', ':TSCStop<CR>', mode = 'n', silent = true, noremap = true, desc = 'TSC stop' },
        },
    },

    {
        'mfussenegger/nvim-lint',
        ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        config = function()
            local lint = require 'lint'

            lint.linters_by_ft = {
                javascript = jsLinters,
                typescript = jsLinters,
                javascriptreact = jsLinters,
                typescriptreact = jsLinters,
            }
            local eslint = lint.linters.eslint_d
            eslint.stdin = true

            local filetype = vim.bo.filetype

            if
                filetype == 'javascript'
                or filetype == 'javascriptreact'
                or filetype == 'typescript'
                or filetype == 'typescript'
            then
                local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

                vim.api.nvim_create_autocmd({
                    'BufEnter',
                    'BufWritePre',
                    'InsertLeave',
                }, {
                    group = lint_augroup,
                    callback = function() lint.try_lint('eslint_d', { cwd = root_dir() }) end,
                })
            end
        end,
    },
}
