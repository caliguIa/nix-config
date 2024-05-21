return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-context',
            {
                'abecodes/tabout.nvim', -- Tab out from parenthesis, quotes, brackets...
                opts = {
                    tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
                    backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
                    completion = false, -- We use tab for completion so set this to true
                },
            },
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup {
                indent = { enable = false },
                ensure_installed = 'all',
                ignore_install = { 'phpdoc' },
                rainbow = {
                    enable = true,
                },
                highlight = {
                    enable = true,
                    max_file_lines = 5000,
                    disable = function(_, buf)
                        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                        -- Disable for files larger than 250 KB.
                        return ok and stats and stats.size > (250 * 1024)
                    end,
                },
            }
            require('treesitter-context').setup {
                max_lines = 3,
            }
        end,
    },

    {

        'windwp/nvim-ts-autotag',
        lazy = false,
        opts = {
            opts = {
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
                filetypes = {
                    'html',
                    'javascript',
                    'typescript',
                    'javascriptreact',
                    'typescriptreact',
                    'tsx',
                    'jsx',
                    'xml',
                    'php',
                    'markdown',
                },
            },
        },
    },
}
