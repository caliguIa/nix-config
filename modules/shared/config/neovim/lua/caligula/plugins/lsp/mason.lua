return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- import mason
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                border = "rounded",
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "tsserver",
                "bashls",
                "html",
                "cssls",
                "tailwindcss",
                "lua_ls",
                "prismals",
                "dockerls",
                "docker_compose_language_service",
                "jsonls",
                "gopls",
                "marksman",
                "nil_ls",
                "phpactor",
                "rust_analyzer",
                "taplo",
                "terraformls",
                "yamlls",
            },
            automatic_installation = true,
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "prettier",
                "prettierd",
                "stylua",
                "eslint_d",
            },
        })
    end,
}
