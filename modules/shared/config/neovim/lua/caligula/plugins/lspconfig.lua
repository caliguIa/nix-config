return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = {} },
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                map("gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                -- map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                map("<leader>e", vim.diagnostic.open_float, "Show line diagnostics")
                map("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
                map("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
                if client and client.server_capabilities.document_formatting then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = event.buf,
                        command = "EslintFixAll",
                    })
                end
            end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            checkThirdParty = false,
                            telemetry = {
                                enable = false,
                            },
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                },
            },
            html = {},
            tsserver = {},
            cssls = {},
            bashls = {},
            dockerls = {},
            rust_analyzer = {},
            taplo = {},
            terraformls = {},
            tailwindcss = {},
            prismals = {},
            yamlls = {},
            docker_compose_language_service = {},
            jsonls = {},
            gopls = {},
            marksman = {},
            nil_ls = {
                settings = {
                    ["nil"] = {
                        formatting = {
                            command = { "nixpkgs-fmt" },
                        },
                    },
                },
            },
            eslint = {
                settings = {
                    workingDirectories = { mode = "auto" },
                },
                root_dir = lspconfig.util.root_pattern(".eslintrc.json"),
            },
            intelephense = {
                root_dir = lspconfig.util.root_pattern("composer.json"),
                init_options = {
                    storagePath = "/tmp/intelephense",
                    globalStoragePath = os.getenv("HOME") .. "/.cache/intelephense",
                    licenceKey = os.getenv("HOME") .. "/.local/auth/intelephense.txt" or "",
                },
            },
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua",
            "prettierd",
            "prettier",
        })

        require("mason").setup({ ui = { border = "rounded" } })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            { underline = true, virtual_text = false, signs = true, update_in_insert = false }
        )

        require("lspconfig.ui.windows").default_options.border = "rounded"
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
}
