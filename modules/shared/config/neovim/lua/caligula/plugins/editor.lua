local icons = require 'caligula.core.icons'

return {
    {
        'ggandor/flit.nvim',
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
    -- TEST:
    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            keywords = {
                TODO = { icon = icons.diagnostics.info, color = 'warning', alt = { 'todo' } },
            },
        },
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
                vim.keymap.set(
                    'n',
                    key,
                    function() require('illuminate')['goto_' .. dir .. '_reference'](false) end,
                    { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer }
                )
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

    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        cmd = 'BqfAutoToggle',
        event = 'QuickFixCmdPost',
        opts = {},
    },
    -- {
    --     'ahmedkhalf/project.nvim', -- Automatically set the cwd to the project root
    --     config = function()
    --         require('project_nvim').setup {}
    --     end,
    -- },
    --
    {
        'kndndrj/nvim-dbee',
        dependencies = {
            'MunifTanjim/nui.nvim',
        },
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require('dbee').install()
        end,
        opts = {},
        -- stylua: ignore
        keys = {
            { '<leader>db', function() require('dbee').toggle() end, mode = 'n', desc = 'Open DBee' },
        },
    },

    {
        'RaafatTurki/corn.nvim',
        event = 'LspAttach',
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
}
