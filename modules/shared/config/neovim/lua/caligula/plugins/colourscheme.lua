return {
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     config = function()
    --         require("catppuccin").setup({
    --             transparent_background = true,
    --             integrations = {
    --                 harpoon = true,
    --                 mason = true,
    --                 cmp = true,
    --                 gitsigns = true,
    --                 treesitter = true,
    --                 mini = true,
    --             },
    --             color_overrides = {
    --                 mocha = {
    --                     base = "#16181a",
    --                 },
    --             },
    --         })
    --     end,
    -- },
    -- {
    --     "nyoom-engineering/oxocarbon.nvim",
    --     name = "oxocarbon",
    --     priority = 1000,
    --     -- Add in any other configuration;
    --     --   event = foo,
    --     --   config = bar
    --     --   end,
    -- },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                -- If you enable compilation, make sure to run :KanagawaCompile command every time you make changes to your config.
                compile = true,
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = true,
                dimInactive = false, -- dim inactive window `:h hl-NormalNC`
                terminalColors = true, -- define vim.g.terminal_color_{0,17}
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        NormalFloat = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        FloatTitle = { bg = "none" },

                        -- Save an hlgroup with dark background and dimmed foreground
                        -- so that you can use it where your still want darker windows.
                        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                        -- Popular plugins that open floats will link to NormalFloat by default;
                        -- set their background accordingly if you wish to keep them dark and borderless
                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                    }
                end,
                colors = { -- add/modify theme and palette colors
                    theme = {
                        all = { ui = {
                            bg_gutter = "none",
                        } },
                    },
                },
                theme = "wave", -- Load "wave" theme when 'background' option is not set
                background = { -- map the value of 'background' option to a theme
                    dark = "wave", -- try "dragon" !
                    light = "lotus",
                },
            })

            vim.cmd("colorscheme kanagawa")
        end,
    },
}
