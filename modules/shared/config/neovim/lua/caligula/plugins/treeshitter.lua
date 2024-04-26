return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPre', 'BufNewFile' },
        version = false,
        build = ':TSUpdate',
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-textobjects",
            'windwp/nvim-ts-autotag',
        },
        opts = {
            highlight = {
                enable = true,
                disable = function(_, buf)
                    -- Don't disable for read-only buffers.
                    if not vim.bo[buf].modifiable then
                        return false
                    end

                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    -- Disable for files larger than 250 KB.
                    return ok and stats and stats.size > (250 * 1024)
                end,
            },
            indent = { enable = true },
            autotag = {
                enable = true,
            },
            ensure_installed = {
                'json',
                'javascript',
                'typescript',
                'tsx',
                'yaml',
                'html',
                'css',
                'prisma',
                'markdown',
                'markdown_inline',
                'svelte',
                'graphql',
                'bash',
                'lua',
                'vim',
                'dockerfile',
                'gitignore',
                'query',
                'go',
                'rust',
                'regex',
                'vimdoc',
                'terraform',
                'toml',
                'nix',
                'php',
                'c',
                'diff',
                'jsdoc',
                'jsonc',
                'luadoc',
                'luap',
                'python',
                'tsx',
                'vimdoc',
                'xml',
            },
            incremental_selection = {
                enable = false,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
            require('ts_context_commentstring').setup()
        end,
    },

    {
        'windwp/nvim-ts-autotag',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
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

    -- {
    --     "yorickpeterse/nvim-tree-pairs",
    --     event = { "BufReadPre", "BufNewFile" },
    --     opts = {},
    -- },
}
