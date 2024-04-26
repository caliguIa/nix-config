return {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-buffer', -- source for text in buffer
            'hrsh7th/cmp-path', -- source for file system paths
            'hrsh7th/cmp-nvim-lsp',
            'saadparwaiz1/cmp_luasnip', -- for autocompletion
            'rafamadriz/friendly-snippets', -- useful snippets
            'onsails/lspkind.nvim', -- vs-code like pictograms
            {
                'L3MON4D3/LuaSnip',
                -- follow latest release.
                version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
                build = 'make install_jsregexp',
            },
        },
        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local lspkind = require 'lspkind'

            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)

            cmp.setup {
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
                    ['<C-e>'] = cmp.mapping.abort(), -- close completion window
                    ['<CR>'] = cmp.mapping.confirm { select = false },
                },
                -- sources for autocompletion
                sources = cmp.config.sources {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- snippets
                    { name = 'buffer' }, -- text within current buffer
                    { name = 'path' }, -- file system paths
                },
                -- configure lspkind for vs-code like pictograms in completion menu
                ---@diagnostic disable-next-line: missing-fields
                formatting = {
                    format = lspkind.cmp_format {
                        maxwidth = 50,
                        ellipsis_char = '...',
                    },
                },
            }
        end,
    },

    {
        'echasnovski/mini.pairs',
        event = 'VeryLazy',
        opts = {
            mappings = {
                ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`].', register = { cr = false } },
            },
        },
    },

    {
        'echasnovski/mini.surround',
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local plugin = require('lazy.core.config').spec.plugins['mini.surround']
            local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
            local mappings = {
                { opts.mappings.add, desc = 'Add Surrounding', mode = { 'n', 'v' } },
                { opts.mappings.delete, desc = 'Delete Surrounding' },
                { opts.mappings.find, desc = 'Find Right Surrounding' },
                { opts.mappings.find_left, desc = 'Find Left Surrounding' },
                { opts.mappings.highlight, desc = 'Highlight Surrounding' },
                { opts.mappings.replace, desc = 'Replace Surrounding' },
                { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = 'gsa', -- Add surrounding in Normal and Visual modes
                delete = 'gsd', -- Delete surrounding
                find = 'gsf', -- Find surrounding (to the right)
                find_left = 'gsF', -- Find surrounding (to the left)
                highlight = 'gsh', -- Highlight surrounding
                replace = 'gsr', -- Replace surrounding
                update_n_lines = 'gsn', -- Update `n_lines`
            },
        },
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },
    {
        'echasnovski/mini.comment',
        event = 'VeryLazy',
        opts = {
            options = {
                custom_commentstring = function()
                    return require('ts_context_commentstring.internal').calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
    },

    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = '<C-a>',
                    accept_word = '<C-s>',
                    accept_line = '<C-l>',
                    next = '<M-]>',
                    prev = '<M-[>',
                    dismiss = '<C-]>',
                },
            },
            filetypes = { ['*'] = true },
        },
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        branch = 'canary',
        dependencies = {
            { 'zbirenbaum/copilot.lua' },
            { 'nvim-lua/plenary.nvim' },
        },
        opts = {
            debug = true, -- Enable debugging
        },
    },
}
