-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
    -- NOTE: First, some plugins that don't require any configuration

    -- Git related plugins
    "tpope/vim-fugitive",
    -- "tpope/vim-rhubarb",

    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",

    -- decorated scrollbar
    {
        "petertriho/nvim-scrollbar",
        config = function()
            require("scrollbar").setup()
        end,
    },

    -- folds
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
            {
                "luukvbaal/statuscol.nvim",
                config = function()
                    local builtin = require("statuscol.builtin")
                    require("statuscol").setup({
                        relculright = true,
                        segments = {
                            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                            { text = { "%s" }, click = "v:lua.ScSa" },
                            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                        },
                    })
                end,
            },
        },
        event = "BufReadPost",
    },
    -- Todo comments
    {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup({})
        end,
    },

    -- Mini.nvim
    {
        "echasnovski/mini.nvim",
        version = "*",
        config = function()
            require("mini.move").setup()
            require("mini.pairs").setup()
            require("mini.surround").setup()
            require("mini.jump").setup()
            require("mini.indentscope").setup()
            require("mini.cursorword").setup()
            require("mini.comment").setup()
            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
            require("mini.files").setup({
                windows = {
                    preview = true,
                    width_preview = 80,
                    width_focus = 35,
                    width_nofocus = 8,
                },
                mappings = {
                    close = "q",
                    go_in_plus = "l",
                },
            })
            require("mini.basics").setup({
                options = {
                    win_borders = "rounded",
                },
                autocommands = {
                    relnum_in_visual_mode = true,
                },
                silent = true,
            })
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-a>",
                        accept_word = "<C-w>",
                        accept_line = "<C-l>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
            })
        end,
    },
    -- {
    -- 	"jellydn/CopilotChat.nvim",
    -- 	opts = {
    -- 		mode = "split", -- newbuffer or split  , default: newbuffer
    -- 	},
    -- 	build = function()
    -- 		vim.defer_fn(function()
    -- 			vim.cmd("UpdateRemotePlugins")
    -- 			vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
    -- 		end, 3000)
    -- 	end,
    -- 	event = "VeryLazy",
    -- 	keys = {
    -- 		{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
    -- 		{ "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
    -- 	},
    -- },

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = {} },
            "folke/neodev.nvim",
        },
    },

    {
        -- Formatting
        "stevearc/conform.nvim",
        event = { "BufWritePre", "BufNewFile" },
        cmd = { "ConformInfo" },
        keys = {},
        -- Everything in opts will be passed to setup()
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "eslint_d", { "prettier", "prettierd" } },
                typescript = { "eslint_d", { "prettier", "prettierd" } },
                javascriptreact = { "eslint_d", { "prettier", "prettierd" } },
                typescriptreact = { "eslint_d", { "prettier", "prettierd" } },
                css = { "eslint_d", { "prettier", "prettierd" } },
                scss = { "eslint_d", { "prettier", "prettierd" } },
                sass = { "eslint_d", { "prettier", "prettierd" } },
                json = { "eslint_d", { "prettier", "prettierd" } },
                yaml = { "eslint_d", { "prettier", "prettierd" } },
                markdown = { "eslint_d", { "prettier", "prettierd" } },
                graphql = { "eslint_d", { "prettier", "prettierd" } },
                nix = { "nixpkgs-fmt" },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            notify_on_error = true,
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint" },
                typescript = { "eslint" },
                javascriptreact = { "eslint" },
                typescriptreact = { "eslint" },
                svelte = { "eslint" },
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })

            vim.keymap.set("n", "<leader>l", function()
                lint.try_lint()
            end, { desc = "Trigger [l]inting for current file" })
        end,
    },
    {
        "oliverhkraft/nvim-pint",
        config = function()
            require("nvim-pint").setup({
                silent = false, -- No notifications
                exclude_folders = { "resources/views" }, -- Accepts comma separated array to exlude folders
            })
        end,
    },

    -- Useful plugin to show you pending keybinds.
    { "folke/which-key.nvim", opts = {} },
    {
        -- Adds git releated signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "▐" },
                change = { text = "▐" },
                delete = { text = "▐" },
                topdelete = { text = "▐" },
                changedelete = { text = "▐" },
                untracked = { text = "▐" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            numhl = false, -- Toggle with `:Gitsigns toggle_nunhl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            sign_priority = 9,
            watch_gitdir = {
                interval = 1000,
            },
            attach_to_untracked = false,
            on_attach = function(bufnr)
                vim.keymap.set(
                    "n",
                    "[c",
                    require("gitsigns").prev_hunk,
                    { buffer = bufnr, desc = "Go to Previous Hunk" }
                )
                vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Go to Next Hunk" })
                vim.keymap.set(
                    "n",
                    "<leader>ph",
                    require("gitsigns").preview_hunk,
                    { buffer = bufnr, desc = "[P]review [H]unk" }
                )
            end,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
                integrations = {
                    harpoon = true,
                    mason = true,
                },
                color_overrides = {
                    mocha = {
                        base = "#16181a",
                    },
                },
            })
        end,
    },
    {
        -- Set lualine as statusline
        "nvim-lualine/lualine.nvim",
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = "catppuccin",
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_c = { { "filename", file_status = true, path = 1 } },
            },
        },
    },

    -- {
    -- 	-- Add indentation guides even on blank lines
    -- 	"lukas-reineke/indent-blankline.nvim",
    -- 	-- Enable `lukas-reineke/indent-blankline.nvim`
    -- 	-- See `:help indent_blankline.txt`
    -- 	main = "ibl",
    -- 	opts = {
    -- 		indent = {
    -- 			char = "┊",
    -- 		},
    -- 	},
    -- },

    -- "gc" to comment visual regions/lines
    -- { "numToStr/Comment.nvim", opts = {} },

    { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope-ui-select.nvim",
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                -- This will not install any breaking changes.
                -- For major updates, this must be adjusted manually.
                version = "^1.0.0",
            },
        },
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
    },

    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
    },

    -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
    --       These are some example plugins that I've included in the kickstart repository.
    --       Uncomment any of the lines below to enable them.
    -- require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',

    -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    -- { import = 'custom.plugins' },
}, {})
