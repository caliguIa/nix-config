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
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            { 'j-hui/fidget.nvim', tag = 'legacy', event = 'LspAttach', opts = {} },
            { 'antosha417/nvim-lsp-file-operations', config = true },
            {
                'folke/neodev.nvim',
                opts = {
                    library = {
                        plugins = {
                            'neotest',
                            'nvim-treesitter',
                            'plenary.nvim',
                        },
                        types = true,
                    },
                },
                config = function()
                    require('neodev').setup {
                        override = function(root_dir, library)
                            if root_dir:find('/Users/caligula/nix-config', 1, true) == 1 then
                                library.enabled = true
                                library.plugins = true
                            end
                        end,
                    }
                end,
            },
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        config = function()
            local lspconfig = require 'lspconfig'
            local fzf_lua = require 'fzf-lua'

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
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

                    map(
                        'gi',
                        function() fzf_lua.lsp_implementations { jump_to_single_result = true } end,
                        '[G]oto [I]mplementation'
                    )

                    map('gt', function() fzf_lua.lsp_typedefs { jump_to_single_result = true } end, 'Type [D]efinition')

                    map('<leader>ds', fzf_lua.lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', fzf_lua.lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', fzf_lua.lsp_code_actions, '[C]ode [A]ction')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gK', vim.lsp.buf.signature_help, 'Hover signature help')
                    map('gD', fzf_lua.lsp_declarations, '[G]oto [D]eclaration')
                    map('<leader>e', vim.diagnostic.open_float, 'Show line diagnostics')
                    map(']d', vim.diagnostic.goto_next, 'Go to next diagnostic')
                    map('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.server_capabilities.documentHighlightProvider then
                    --     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    -- end
                    if client and client.server_capabilities.document_formatting then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = event.buf,
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
                                library = {
                                    [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                                    [vim.fn.stdpath 'config' .. '/lua'] = true,
                                },
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

            vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                { underline = true, virtual_text = false, signs = false, update_in_insert = false }
            )
            vim.diagnostic.config { virtual_text = false, signs = false, underline = true }

            require('lspconfig.ui.windows').default_options.border = 'single'
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
            vim.lsp.handlers['textDocument/signatureHelp'] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
        end,
    },

    {
        'kosayoda/nvim-lightbulb',
        opts = {
            autocmd = {
                enabled = true,
            },
        },
    },

    {
        'pmizio/typescript-tools.nvim',
        event = { 'BufReadPre *.ts,*.tsx,*.js,*.jsx', 'BufNewFile *.ts,*.tsx,*.js,*.jsx' },
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
        event = { 'BufReadPre *.ts,*.tsx,*.js,*.jsx', 'BufNewFile *.ts,*.tsx,*.js,*.jsx' },
        opts = {},
    },

    {
        'dmmulroy/tsc.nvim',
        cmd = { 'TSC', 'TSCStop' },
        opts = {
            use_trouble_qflist = false,
            run_as_monorepo = false,
        },
    },

    {
        'ccaglak/phptools.nvim',
        keys = {
            { '<leader>lm', '<cmd>PhpMethod<cr>' },
            { '<leader>lc', '<cmd>PhpClass<cr>' },
            { '<leader>ls', '<cmd>PhpScripts<cr>' },
            { '<leader>ln', '<cmd>PhpNamespace<cr>' },
            { '<leader>lg', '<cmd>PhpGetSet<cr>' },
            { '<leader>lf', '<cmd>PhpCreate<cr>' },
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('phptools').setup {
                ui = false, -- if you have stevearc/dressing.nvim or something similar keep it false or else true
            }
            vim.keymap.set('v', '<leader>lr', ':PhpRefactor<cr>')
        end,
    },

    {
        'adalessa/laravel.nvim',
        ft = 'php',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'tpope/vim-dotenv',
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        },
        cmd = { 'Sail', 'Artisan', 'Composer', 'Npm', 'Laravel', 'LaravelInfo' },
        keys = {
            { '<leader>la', ':Laravel artisan<cr>' },
            { '<leader>lr', ':Laravel routes<cr>' },
            { '<leader>lR', ':Laravel related<cr>' },
        },
        event = { 'VeryLazy' },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('laravel').setup {
                lsp_server = 'intelephense',
                ---@diagnostic disable-next-line: missing-fields
                features = {
                    null_ls = {
                        enable = false,
                    },
                },
                route_info = {
                    position = 'top',
                },
                ui = require 'laravel.config.ui',
                commands_options = require 'laravel.config.command_options',
                environments = require 'laravel.config.environments',
                user_commands = require 'laravel.config.user_commands',
                resources = require 'laravel.config.resources',
                -- environment = {
                --     environments = {
                --         ['ao'] = require('laravel.environment.docker_compose').setup {
                --             container_name = 'panel-webserver',
                --             cmd = { 'docker', 'compose', 'exec', '-u', user_arg, '-it', 'panel-webserver' },
                --         },
                --     },
                -- },
            }
            local tele_status_ok, telescope = pcall(require, 'telescope')
            if not tele_status_ok then return end

            telescope.load_extension 'laravel'
        end,
    },

    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPre *.ts,*.tsx,*.js,*.jsx', 'BufNewFile *.ts,*.tsx,*.js,*.jsx' },
        config = function()
            local lint = require 'lint'

            lint.linters_by_ft = {
                -- lua = { 'selene' },
                php = { 'php' },

                javascript = jsLinters,
                typescript = jsLinters,
                javascriptreact = jsLinters,
                typescriptreact = jsLinters,
            }
            local eslint = lint.linters.eslint_d
            eslint.stdin = true
            -- eslint.args = {
            --     '--no-warn-ignored', -- <-- this is the key argument
            --     '--format',
            --     'json',
            --     '--config=' .. root_dir() .. '/.eslintrc.json',
            --     '--stdin',
            --     '--stdin-filename',
            --     function() return vim.api.nvim_buf_get_name(0) end,
            -- }

            local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

            vim.api.nvim_create_autocmd({
                'BufEnter',
                'BufWritePre',
                'BufWritePost',
                'InsertEnter',
                'InsertLeave',
                'TextChanged',
            }, {
                group = lint_augroup,
                callback = function()
                    -- lint.try_lint()
                    lint.try_lint('eslint_d', { cwd = root_dir() })
                    -- lint.try_lint('eslint_d', { cwd = vim.fn.getcwd() .. '/resources/client' })
                    -- lint.try_lint('eslint', { cwd = vim.fn.getcwd() .. '/resources/client' })
                end,
            })

            -- vim.keymap.set('n', '<leader>ll', function() lint.try_lint() end, { desc = 'Trigger linting for current file' })
        end,
    },
}
