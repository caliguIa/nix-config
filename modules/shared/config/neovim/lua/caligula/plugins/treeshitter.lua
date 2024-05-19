return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            {
                'windwp/nvim-ts-autotag', -- Autoclose and autorename HTML and Vue tags
                config = true,
            },
            {
                'nvim-treesitter/nvim-treesitter-context',
                opts = {
                    event = { 'BufReadPre', 'BufNewFile' },
                },
            },
            -- 'nvim-treesitter/nvim-treesitter-textobjects', -- Syntax aware text-objects, select, move, swap, and peek support.
            'JoosepAlviste/nvim-ts-context-commentstring', -- Smart commenting in multi language files - Enabled in Treesitter file
            {
                'abecodes/tabout.nvim', -- Tab out from parenthesis, quotes, brackets...
                opts = {
                    tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
                    backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
                    completion = true, -- We use tab for completion so set this to true
                },
            },
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup {
                indent = { enable = false },
                autotag = {
                    enable = true,
                    enable_rename = true,
                    enable_close = true,
                    enable_close_on_slash = true,
                    filetypes = {
                        'html',
                        'javascript',
                        'typescript',
                        'javascriptreact',
                        'typescriptreact',
                        'svelte',
                        'vue',
                        'tsx',
                        'jsx',
                        'rescript',
                        'xml',
                        'php',
                        'markdown',
                        'astro',
                        'glimmer',
                        'handlebars',
                        'hbs',
                    },
                },
                ensure_installed = 'all',
                ignore_install = { 'phpdoc' },
                highlight = {
                    enable = true,
                    max_file_lines = 5000,
                    disable = function(_, buf)
                        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                        -- Disable for files larger than 250 KB.
                        return ok and stats and stats.size > (250 * 1024)
                    end,
                },
                incremental_selection = {
                    enable = false,
                    keymaps = {
                        init_selection = '<M-w>',
                        scope_incremental = '<CR>',
                        node_incremental = '<Tab>', -- increment to the upper named parent
                        node_decremental = '<S-Tab>', -- decrement to the previous node
                    },
                },
            }
            require('ts_context_commentstring').setup()
        end,
    },

    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'BufReadPre', 'BufNewFile' },
        opts = { use_default_keymaps = false },
        -- stylua: ignore
        keys = {
            { mode = { "n" }, "<leader>ct", function () require("treesj").toggle() end,  desc = "[C]ode chunk toggle split/join"  },
            { mode = { "n" }, "<leader>cs", function () require("treesj").split() end,  desc = "C]ode chunk [s]plit"  },
            { mode = { "n" }, "<leader>cj", function () require("treesj").join() end,  desc = "[C]ode chunk [j]oin"  },
        },
    },
}
