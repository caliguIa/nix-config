local icons = require("caligula.core.icons")

return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        -- stylua: ignore
        keys = {
          { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
          { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },

    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        keys = {
            { "<leader>s.", "<cmd>FzfLua resume<cr>", desc = "Resume last command" },
            {
                "<leader>s/",
                function()
                    require("fzf-lua").lgrep_curbuf({
                        winopts = {
                            height = 0.8,
                            width = 0.7,
                            preview = { vertical = "up:70%" },
                        },
                    })
                end,
                desc = "Grep current buffer",
            },
            { "<leader>sc", "<cmd>FzfLua highlights<cr>", desc = "Highlights" },
            { "<leader>sd", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "Document diagnostics" },
            { "<leader>sD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
            { "<leader>sf", "<cmd>FzfLua files<cr>", desc = "Files" },
            { "<leader>sg", "<cmd>FzfLua live_grep_glob<cr>", desc = "Live Grep" },
            { "<leader>sv", "<cmd>FzfLua grep_visual<cr>", desc = "Visual Grep", mode = "x" },
            { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
            { "<leader>sb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
            {
                "<leader>sr",
                function()
                    -- Read from ShaDa to include files that were already deleted from the buffer list.
                    vim.cmd("rshada!")
                    require("fzf-lua").oldfiles()
                end,
                desc = "Recently opened files",
            },
        },

        opts = function()
            local actions = require("fzf-lua.actions")

            return {
                -- Make stuff better combine with the editor.
                fzf_colors = {
                    ["bg"] = { "bg", "Normal" },
                    ["gutter"] = "-1",
                    ["bg+"] = { "bg", "Normal" },
                    ["info"] = { "fg", "Conditional" },
                    ["scrollbar"] = { "bg", "Normal" },
                    ["separator"] = { "fg", "Comment" },
                },
                fzf_opts = {
                    ["--info"] = "default",
                    ["--layout"] = "reverse-list",
                },
                keymap = {
                    builtin = {
                        ["<C-/>"] = "toggle-help",
                        ["<C-a>"] = "toggle-fullscreen",
                        ["<C-i>"] = "toggle-preview",
                        ["<C-f>"] = "preview-page-down",
                        ["<C-b>"] = "preview-page-up",
                    },
                    fzf = {
                        ["alt-s"] = "toggle",
                        ["alt-a"] = "toggle-all",
                    },
                },
                winopts = {
                    height = 0.8,
                    width = 0.7,
                    preview = {
                        scrollbar = false,
                        layout = "vertical",
                        vertical = "up:40%",
                    },
                },
                global_git_icons = false,
                -- Configuration for specific commands.
                files = {
                    winopts = {
                        preview = { hidden = "hidden" },
                    },
                },
                grep = {
                    header_prefix = icons.misc.search .. " ",
                },
                helptags = {
                    actions = {
                        -- Open help pages in a vertical split.
                        ["default"] = actions.help_vert,
                    },
                },
                lsp = {
                    symbols = {
                        symbol_icons = icons.symbol_kinds,
                    },
                },
                oldfiles = {
                    include_current_session = true,
                    winopts = {
                        preview = { hidden = "hidden" },
                    },
                },
            }
        end,
    },

    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {
            disabled_filetypes = { "qf", "NeogitStatus", "octo", "lazy", "mason", "oil" },
        },
    },

    {
        "ThePrimeagen/harpoon",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, desc = "[H]arpoon menu" },
            { "ma", function() require("harpoon.mark").add_file() end, desc = "[M]ark [A]dd" },
            { "mj", function() require("harpoon.ui").nav_file(1) end, desc = "Jump to [M]ark [1]" },
            { "mk", function() require("harpoon.ui").nav_file(2) end, desc = "Jump to [M]ark [2]" },
            { "ml", function() require("harpoon.ui").nav_file(3) end, desc = "Jump to [M]ark [3]" },
            { "m;", function() require("harpoon.ui").nav_file(4) end, desc = "Jump to [M]ark [4]" },
        },
    },

    {
        "kevinhwang91/nvim-hlslens",
        opts = {},
        keys = {
            { "*", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>" },
            { "#", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>" },
            { "g*", "<Cmd>execute('normal! ' . v:count1 . 'g*')<CR><Cmd>lua require('hlslens').start()<CR>" },
            { "g#", "<Cmd>execute('normal! ' . v:count1 . 'g#')<CR><Cmd>lua require('hlslens').start()<CR>" },
        },
    },

    {
        "stevearc/oil.nvim",
        opts = {
            default_file_explorer = true,
            columns = { "icon" },
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
            view_options = {
                show_hidden = true,
            },
        },
        keys = {
            { "<leader>fe", "<CMD>Oil<CR>", desc = "Toggle [F]ile [E]xplorer" },
        },
    },

    {
        "cshuaimin/ssr.nvim",
        -- stylua: ignore
        keys = {
            { "<leader>sR", function() require("ssr").open() end, mode = { "n", "x" }, desc = "Structural Replace", },
        },
        opts = {},
    },

    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },

    {
        "folke/trouble.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { use_diagnostic_signs = true },
        -- stylua: ignore
        keys = {
            { "<leader>xx", function() require("trouble").toggle() end, desc = "Trouble toggle" },
            { "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, desc = "[W]orkspace diagnostics" },
            { "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, desc = "[D]ocument diagnostics" },
            { "<leader>xq", function() require("trouble").toggle("quickfix") end, desc = "[Q]uickfix" },
            { "<leader>xl", function() require("trouble").toggle("loclist") end, desc = "[L]ocation list" },
        },
    },

    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        -- stylua: ignore
        keys = {
            { "<leader>u", function() require("undotree").toggle() end, desc = "Toggle undotree" },
        },
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },

    {
        "anuvyklack/windows.nvim",
        dependencies = { "anuvyklack/middleclass" },
        opts = {
            autowidth = {
                enable = false,
            },
            animation = {
                enable = false,
            },
        },
        keys = {
            { "<leader>wm", "<CMD>WindowsMaximize<CR>", desc = "[W]indow [m]aximize" },
        },
    },
}
