local icons = require 'caligula.core.icons'
local diagnostics_icons = require('caligula.core.icons').diagnostics

local diagnostics = {
    'diagnostics',
    sections = { 'error', 'warn' },
    colored = true, -- Displays diagnostics status in color if set to true.
    always_visible = true, -- Show diagnostics even if there are none.
    symbols = {
        error = diagnostics_icons.ERROR,
        warn = diagnostics_icons.WARN,
        hint = diagnostics_icons.HINT,
        info = diagnostics_icons.INFO,
    },
}

return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        opts = function()
            local logo = [[ neobim ]]
            logo = string.rep('\n', 8) .. logo .. '\n\n'

            local opts = {
                theme = 'doom',
                hide = {
                    statusline = false,
                },
                config = {
                    header = vim.split(logo, '\n'),
                    -- stylua: ignore
                    center = {
                        { action = "ene | startinsert",                 desc = " New File",        icon = icons.symbol_kinds.File,      key = "n" },
                        { action = "Oil",                               desc = " File explorer",   icon = icons.symbol_kinds.Folder,    key = "e" },
                        { action = "FzfLua files",                      desc = " Find File",       icon = icons.misc.search,            key = "f" },
                        { action = "FzfLua live_grep_glob",             desc = " Find Text",       icon = icons.misc.text,              key = "g" },
                        { action = 'lua require("persistence").load()', desc = " Restore Session", icon = icons.misc.restore,           key = "r" },
                        { action = "Lazy",                              desc = " Lazy",            icon = icons.misc.lazy,              key = "l" },
                        { action = "qa",                                desc = " Quit",            icon = icons.misc.quit,              key = "q" },
                    },
                    footer = function()
                        local stats = require('lazy').stats()
                        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                        return {
                            icons.misc.bolt
                                .. ' Neovim loaded '
                                .. stats.loaded
                                .. '/'
                                .. stats.count
                                .. ' plugins in '
                                .. ms
                                .. 'ms',
                        }
                    end,
                },
            }

            for _, button in ipairs(opts.config.center) do
                button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
                button.key_format = '  %s'
            end

            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == 'lazy' then
                vim.cmd.close()
                vim.api.nvim_create_autocmd('User', {
                    pattern = 'DashboardLoaded',
                    callback = function()
                        require('lazy').show()
                    end,
                })
            end

            return opts
        end,
    },

    {
        'stevearc/dressing.nvim',
        lazy = true,
        opts = {
            input = {
                win_options = {
                    -- Use a purple-ish border.
                    winhighlight = 'FloatBorder:LspFloatWinBorder',
                    winblend = 5,
                },
            },
            select = {
                trim_prompt = false,
                get_config = function(opts)
                    if opts.kind == 'codeaction' then
                        -- Cute and compact code action menu.
                        return {
                            backend = 'builtin',
                            builtin = {
                                relative = 'cursor',
                                max_height = 0.33,
                                min_height = 5,
                                max_width = 0.40,
                                mappings = { ['q'] = 'Close' },
                                win_options = {
                                    -- Same UI as the input field.
                                    winhighlight = 'FloatBorder:LspFloatWinBorder,DressingSelectIdx:LspInfoTitle,MatchParen:Ignore',
                                    winblend = 5,
                                },
                            },
                        }
                    end

                    local winopts = { height = 0.6, width = 0.5 }

                    -- Smaller menu for snippet choices.
                    if opts.kind == 'luasnip' then
                        opts.prompt = 'Snippet choice: '
                        winopts = { height = 0.35, width = 0.3 }
                    end

                    -- Fallback to fzf-lua.
                    return {
                        backend = 'fzf_lua',
                        fzf_lua = { winopts = winopts },
                    }
                end,
            },
        },
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.input(...)
            end
        end,
    },

    {
        'brenoprata10/nvim-highlight-colors',
        event = { 'BufReadPost', 'BufWritePost' },
        config = function()
            require('nvim-highlight-colors').setup {
                render = 'virtual',
                virtual_symbol = icons.misc.circle,
                enable_tailwind = true,
            }
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'AndreM222/copilot-lualine',
        },
        opts = {
            options = {
                icons_enabled = false,
                theme = 'tokyonight',
                disabled_filetypes = { 'oil', 'dashboard', 'DashboardLoaded', 'dashboard' },
                component_separators = '',
                section_separators = '',
            },
            extensions = { 'trouble' },
            sections = {
                lualine_a = { 'branch' },
                lualine_b = {},
                lualine_c = {
                    {
                        'filename',
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                    },
                },
                lualine_x = {
                    'progress',
                    { require('lazy.status').updates, cond = require('lazy.status').has_updates },
                    'copilot',
                    'diff',
                    diagnostics,
                },
                lualine_y = {},
                lualine_z = {},
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        'filename',
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                    },
                },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },
        },
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        main = 'ibl',
        opts = {
            indent = {
                char = '│',
                tab_char = '│',
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    'help',
                    'alpha',
                    'Trouble',
                    'trouble',
                    'lazy',
                    'mason',
                    'oil',
                    'Oil',
                },
            },
        },
    },

    {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons', -- optional dependency
        },
        config = function()
            -- triggers CursorHold event faster
            -- vim.opt.updatetime = 200

            require('barbecue').setup {
                create_autocmd = false, -- prevent barbecue from updating itself automatically
                theme = 'tokyonight',
                show_modified = true,
            }

            vim.api.nvim_create_autocmd({
                'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
                'BufWinEnter',
                'CursorHold',
                'InsertLeave',

                -- include this if you have set `show_modified` to `true`
                'BufModifiedSet',
            }, {
                group = vim.api.nvim_create_augroup('barbecue.updater', {}),
                callback = function()
                    require('barbecue.ui').update()
                end,
            })
        end,
    },
}
