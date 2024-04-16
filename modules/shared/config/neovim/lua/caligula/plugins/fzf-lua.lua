local icons = require("caligula.core.icons")

return {
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
}
