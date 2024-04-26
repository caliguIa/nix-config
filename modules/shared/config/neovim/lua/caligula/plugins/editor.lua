local icons = require 'caligula.core.icons'

return {
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        opts = {},
        -- stylua: ignore
        keys = {
          { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
          { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },

    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        -- stylua: ignore
        keys = {
            { "<leader>s.", "<cmd>FzfLua resume<cr>", desc = "Resume last command" },
            { "<leader>s/", function() require("fzf-lua").lgrep_curbuf({ winopts = { height = 0.8, width = 0.7, preview = { vertical = "up:70%" }, }, }) end, desc = "Grep current buffer", },
            { "<leader>sc", function() require('fzf-lua').highlights({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Highlights" },
            { "<leader>sd", function() require('fzf-lua').lsp_document_diagnostics({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Document diagnostics" },
            { "<leader>sD", function() require('fzf-lua').lsp_workspace_diagnostics({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Workspace diagnostics" },
            { "<leader>sf", function() require('fzf-lua').files({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Files" },
            { "<leader>sg", function() require('fzf-lua').live_grep_glob({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Live Grep" },
            { "<leader>sv", function() require('fzf-lua').grep_visual({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Visual Grep", mode = "x" },
            { "<leader>sh", function() require('fzf-lua').help_tags({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Help" },
            { "<leader>sb", function() require('fzf-lua').buffers({ fzf_opts = { ['--keep-right'] = '' }}) end, desc = "Buffers" },
            -- { "<leader>sr", function() vim.cmd("rshada!") require("fzf-lua").oldfiles() end, desc = "Recently opened files", },
        },

        opts = function()
            local actions = require 'fzf-lua.actions'

            return {
                -- Make stuff better combine with the editor.
                fzf_colors = {
                    ['bg'] = { 'bg', 'Normal' },
                    ['gutter'] = '-1',
                    ['bg+'] = { 'bg', 'Normal' },
                    ['info'] = { 'fg', 'Conditional' },
                    ['scrollbar'] = { 'bg', 'Normal' },
                    ['separator'] = { 'fg', 'Comment' },
                },
                fzf_opts = {
                    ['--info'] = 'hidden',
                    ['--layout'] = 'reverse-list',
                    ['--keep-right'] = '',
                },
                keymap = {
                    builtin = {
                        ['<C-/>'] = 'toggle-help',
                        ['<C-a>'] = 'toggle-fullscreen',
                        ['<C-i>'] = 'toggle-preview',
                        ['<C-f>'] = 'preview-page-down',
                        ['<C-b>'] = 'preview-page-up',
                    },
                    fzf = {
                        ['alt-s'] = 'toggle',
                        ['alt-a'] = 'toggle-all',
                    },
                },
                winopts = {
                    height = 0.8,
                    width = 0.7,
                    preview = {
                        scrollbar = false,
                        layout = 'vertical',
                        vertical = 'up:40%',
                    },
                },
                global_git_icons = false,
                -- Configuration for specific commands.
                files = {
                    winopts = {
                        preview = { hidden = 'hidden' },
                    },
                },
                grep = {
                    header_prefix = icons.misc.search .. ' ',
                },
                helptags = {
                    actions = {
                        -- Open help pages in a vertical split.
                        ['default'] = actions.help_vert,
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
                        preview = { hidden = 'hidden' },
                    },
                },
            }
        end,
    },

    -- {
    --     "m4xshen/hardtime.nvim",
    --     dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    --     opts = {
    --         disabled_filetypes = { "qf", "NeogitStatus", "octo", "lazy", "mason", "oil", "copilot-chat" },
    --     },
    -- },

    {
        'ThePrimeagen/harpoon',
        dependencies = {
            'nvim-lua/plenary.nvim',
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
        'kevinhwang91/nvim-hlslens',
        opts = {},
        keys = {
            { '*', "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>" },
            { '#', "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>" },
            { 'g*', "<Cmd>execute('normal! ' . v:count1 . 'g*')<CR><Cmd>lua require('hlslens').start()<CR>" },
            { 'g#', "<Cmd>execute('normal! ' . v:count1 . 'g#')<CR><Cmd>lua require('hlslens').start()<CR>" },
        },
    },

    {
        'stevearc/oil.nvim',
        opts = {
            default_file_explorer = true,
            columns = { 'icon' },
            win_options = {
                wrap = false,
                signcolumn = 'no',
                cursorcolumn = false,
                foldcolumn = '0',
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = 'nvic',
            },
            view_options = {
                show_hidden = true,
            },
        },
        keys = {
            { '<leader>fe', '<CMD>Oil<CR>', desc = 'Toggle [F]ile [E]xplorer' },
        },
    },

    {
        'cshuaimin/ssr.nvim',
        -- stylua: ignore
        keys = {
            { "<leader>sR", function() require("ssr").open() end, mode = { "n", "x" }, desc = "Structural Replace", },
        },
        opts = {},
    },
    {
        'nvim-pack/nvim-spectre',
        cmd = 'Spectre',
        opts = {
            open_cmd = 'noswapfile vnew',
            default = { replace = { cmd = 'sd' } },
        },
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "[S]earch & [r]eplace" },
        },
    },

    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {},
    },

    {
        'folke/trouble.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'nvim-tree/nvim-web-devicons' },
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
        'jiaoshijie/undotree',
        dependencies = 'nvim-lua/plenary.nvim',
        config = true,
        -- stylua: ignore
        keys = {
            { "<leader>u", function() require("undotree").toggle() end, desc = "Toggle undotree" },
        },
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {},
    },

    {
        'anuvyklack/windows.nvim',
        dependencies = { 'anuvyklack/middleclass' },
        opts = {
            autowidth = {
                enable = false,
            },
            animation = {
                enable = false,
            },
        },
        keys = {
            { '<leader>wm', '<CMD>WindowsMaximize<CR>', desc = '[W]indow [m]aximize' },
        },
    },

    {
        'RRethy/vim-illuminate',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { 'lsp' },
            },
        },
        config = function(_, opts)
            require('illuminate').configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set('n', key, function()
                    require('illuminate')['goto_' .. dir .. '_reference'](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
            end

            map(']]', 'next')
            map('[[', 'prev')

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map(']]', 'next', buffer)
                    map('[[', 'prev', buffer)
                end,
            })
        end,
        keys = {
            { ']]', desc = 'Next Reference' },
            { '[[', desc = 'Prev Reference' },
        },
    },
}
