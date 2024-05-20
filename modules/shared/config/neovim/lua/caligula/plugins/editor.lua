local icons = require 'caligula.core.icons'

return {
    {
        'ggandor/flit.nvim',
        lazy = false,
        keys = function()
            local ret = {}
            for _, key in ipairs { 'f', 'F', 't', 'T' } do
                ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
            end
            return ret
        end,
        opts = { labeled_modes = 'nx' },
    },
    {
        'ggandor/leap.nvim',
        lazy = false,
        keys = {
            { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap Forward to' },
            { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap Backward to' },
            { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from Windows' },
        },
        config = function(_, opts)
            local leap = require 'leap'
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
            vim.keymap.del({ 'x', 'o' }, 'x')
            vim.keymap.del({ 'x', 'o' }, 'X')
        end,
    },

    {
        'ibhagwan/fzf-lua',
        lazy = false,
        cmd = 'FzfLua',
        -- stylua: ignore
        keys = {
            { "<leader>s.", "<cmd>FzfLua resume<cr>", desc = "Resume last command" },
            { "<leader>s/", function() require("fzf-lua").lgrep_curbuf() end, desc = "Grep current buffer" },
            { "<leader>sc", function() require('fzf-lua').highlights() end, desc = "Highlights" },
            { "<leader>sd", function() require('fzf-lua').lsp_document_diagnostics() end, desc = "Document diagnostics" },
            { "<leader>sD", function() require('fzf-lua').lsp_workspace_diagnostics() end, desc = "Workspace diagnostics" },
            { "<leader>sf", function() require('fzf-lua').files() end, desc = "Files" },
            { "<leader>sg", function() require('fzf-lua').live_grep_glob() end, desc = "Live Grep" },
            { "<leader>sv", function() require('fzf-lua').grep_visual() end, desc = "Visual Grep", mode = "x" },
            { "<leader>sh", function() require('fzf-lua').help_tags() end, desc = "Help" },
            { "<leader>sb", function() require('fzf-lua').buffers() end, desc = "Buffers" },
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
            }
        end,
    },

    {
        'ThePrimeagen/harpoon',
        lazy = false,
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
        lazy = false,
        opts = {},
        keys = {
            {
                'n',
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                silent = true,
                noremap = true,
                mode = 'n',
            },
            {
                'N',
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                silent = true,
                noremap = true,
                mode = 'n',
            },
            { '*', [[*<Cmd>lua require('hlslens').start()<CR>]], silent = true, noremap = true, mode = 'n' },
            { '#', [[#<Cmd>lua require('hlslens').start()<CR>]], silent = true, noremap = true, mode = 'n' },
            { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], silent = true, noremap = true, mode = 'n' },
            { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], silent = true, noremap = true, mode = 'n' },
        },
    },

    {
        'stevearc/oil.nvim',
        lazy = false,
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
        'MagicDuck/grug-far.nvim',
        lazy = false,
        opts = {},
        keys = {
            {
                '<leader>sR',
                '<CMD>lua require("grug-far").grug_far({ prefills = { search = vim.fn.expand("<cword>") } })<CR>',
                desc = '[S]earch & [R]eplace project',
                silent = true,
                mode = { 'n', 'v' },
            },
            {
                '<leader>sr',
                '<CMD>lua require("grug-far").grug_far({ prefills = { flags = vim.fn.expand("%"), search = vim.fn.expand("<cword>") } })<CR>',
                desc = '[S]earch & [R]eplace buffer',
                silent = true,
                mode = { 'n', 'v' },
            },
        },
    },

    {
        'folke/todo-comments.nvim',
        lazy = false,
        opts = {
            keywords = {
                TODO = { icon = icons.diagnostics.info, color = 'warning', alt = { 'todo' } },
            },
        },
    },

    {
        'folke/trouble.nvim',
        lazy = false,
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
        lazy = false,
        dependencies = 'nvim-lua/plenary.nvim',
        config = true,
        -- stylua: ignore
        keys = {
            { "<leader>u", function() require("undotree").toggle() end, desc = "Toggle undotree" },
        },
    },

    {
        'folke/which-key.nvim',
        lazy = false,
        opts = {},
    },

    {
        'anuvyklack/windows.nvim',
        lazy = false,
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

    { 'echasnovski/mini.cursorword', version = false, opts = {}, lazy = false },

    {
        'RaafatTurki/corn.nvim',
        lazy = false,
        opts = {
            icons = {
                error = icons.diagnostics.error,
                warn = icons.diagnostics.warn,
                hint = icons.diagnostics.hint,
                info = icons.diagnostics.info,
            },
            item_preprocess_func = function(item) return item end,
        },
        -- stylua: ignore
        keys = {
            { '<leader>Et', function() require 'corn'.toggle() end, desc = '[E]rrors [t]oggle' },
            { '<leader>Es', function() require 'corn'.scope_cycle() end, desc = '[E]rrors [s]cope' },
        },
    },

    {
        'folke/persistence.nvim',
        lazy = false,
        opts = { options = vim.opt.sessionoptions:get() },
        -- stylua: ignore
        keys = {
          { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
          { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
          { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
        },
    },

    {
        'sontungexpt/url-open',
        event = 'VeryLazy',
        lazy = false,
        cmd = 'URLOpenUnderCursor',
        opts = {},
        keys = {
            { 'gx', '<ESC>:URLOpenUnderCursor<CR>', mode = { 'n' }, desc = 'Open URL under cursor' },
        },
    },

    'tpope/vim-sleuth',

    'nvim-lua/plenary.nvim',

    { 'echasnovski/mini.basics', version = '*' },
}
