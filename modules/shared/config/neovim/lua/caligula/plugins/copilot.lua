return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-a>",
                        accept_word = "<C-s>",
                        accept_line = "<C-l>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
                filetypes = { ["*"] = true },
            })
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        event = { "BufReadPost", "BufNewFile" },
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            debug = true, -- Enable debugging
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     optional = true,
    --     event = "VeryLazy",
    --     opts = function(_, opts)
    --         local colors = {
    --             [""] = LazyVim.ui.fg("Special"),
    --             ["Normal"] = LazyVim.ui.fg("Special"),
    --             ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
    --             ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
    --         }
    --         table.insert(opts.sections.lualine_x, 2, {
    --             function()
    --                 local icon = require("lazyvim.config").icons.kinds.Copilot
    --                 local status = require("copilot.api").status.data
    --                 return icon .. (status.message or "")
    --             end,
    --             cond = function()
    --                 if not package.loaded["copilot"] then
    --                     return
    --                 end
    --                 local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
    --                 if not ok then
    --                     return false
    --                 end
    --                 return ok and #clients > 0
    --             end,
    --             color = function()
    --                 if not package.loaded["copilot"] then
    --                     return
    --                 end
    --                 local status = require("copilot.api").status.data
    --                 return colors[status.status] or colors[""]
    --             end,
    --         })
    --     end,
    -- },

    -- copilot cmp source
    -- {
    --     "nvim-cmp",
    --     dependencies = {
    --         {
    --             "zbirenbaum/copilot-cmp",
    --             dependencies = "copilot.lua",
    --             opts = {},
    --             config = function(_, opts)
    --                 local copilot_cmp = require("copilot_cmp")
    --                 copilot_cmp.setup(opts)
    --                 -- attach cmp source whenever copilot attaches
    --                 -- fixes lazy-loading issues with the copilot cmp source
    --                 LazyVim.lsp.on_attach(function(client)
    --                     if client.name == "copilot" then
    --                         copilot_cmp._on_insert_enter({})
    --                     end
    --                 end)
    --             end,
    --         },
    --     },
    --     opts = function(_, opts)
    --         table.insert(opts.sources, 1, {
    --             name = "copilot",
    --             group_index = 1,
    --             priority = 100,
    --         })
    --     end,
    -- },
}
