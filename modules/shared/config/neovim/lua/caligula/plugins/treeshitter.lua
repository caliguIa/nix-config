return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        -- "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
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
                "json",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "html",
                "css",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "go",
                "rust",
                "regex",
                "vimdoc",
                "terraform",
                "toml",
                "nix",
                "php",
            },
            incremental_selection = {
                enable = false,
            },
        })

        require("ts_context_commentstring").setup({})
    end,
}
