return {
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        priority = 100,
        dependencies = {
            'hrsh7th/cmp-buffer', -- source for text in buffer
            'hrsh7th/cmp-path', -- source for file system paths
            'hrsh7th/cmp-nvim-lsp',
            'saadparwaiz1/cmp_luasnip', -- for autocompletion
            'rafamadriz/friendly-snippets', -- useful snippets
            'onsails/lspkind.nvim', -- vs-code like pictograms
            { 'L3MON4D3/LuaSnip', version = 'v2.*', build = 'make install_jsregexp' },
        },
        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local lspkind = require 'lspkind'

            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}

            cmp.setup {
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args) luasnip.lsp_expand(args.body) end,
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
        lazy = false,
        opts = {
            mappings = {
                ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`].', register = { cr = false } },
            },
        },
    },

    {
        'echasnovski/mini.surround',
        lazy = false,
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local plugin = require('lazy.core.config').spec.plugins['mini.surround']
            local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
            local mappings = {
                { opts.mappings.add, desc = 'Add Surrounding', mode = { 'v' } },
                { opts.mappings.delete, desc = 'Delete Surrounding', mode = { 'n' } },
                { opts.mappings.highlight, desc = 'Highlight Surrounding' },
                { opts.mappings.replace, desc = 'Replace Surrounding' },
            }
            mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = 'gsa', -- Add surrounding in Normal and Visual modes
                delete = 'gsd', -- Delete surrounding
                highlight = 'gsh', -- Highlight surrounding
                replace = 'gsr', -- Replace surrounding
            },
        },
    },

    {
        'zbirenbaum/copilot.lua',
        lazy = false,
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
        cmd = 'CopilotChat',
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
