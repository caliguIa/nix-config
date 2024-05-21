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

local diff = {
    'diff',
    source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
            return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
            }
        end
    end,
    symbols = {
        added = icons.git.LineAdded .. ' ',
        modified = icons.git.LineModified .. ' ',
        removed = icons.git.LineRemoved .. ' ',
    },
    colored = true,
    always_visible = true,
}

local function getLspName()
    local buf_clients = vim.lsp.get_active_clients()
    local buf_ft = vim.bo.filetype
    if next(buf_clients) == nil then return '  No servers' end
    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
        if client.name ~= 'null-ls' then table.insert(buf_client_names, client.name) end
    end

    local lint_s, lint = pcall(require, 'lint')
    if lint_s then
        for ft_k, ft_v in pairs(lint.linters_by_ft) do
            if type(ft_v) == 'table' then
                for _, linter in ipairs(ft_v) do
                    if buf_ft == ft_k then table.insert(buf_client_names, linter) end
                end
            elseif type(ft_v) == 'string' then
                if buf_ft == ft_k then table.insert(buf_client_names, ft_v) end
            end
        end
    end

    local ok, conform = pcall(require, 'conform')
    local formatters = table.concat(conform.list_formatters_for_buffer(), ' ')
    if ok then
        for formatter in formatters:gmatch '%w+' do
            if formatter then table.insert(buf_client_names, formatter) end
        end
    end

    local hash = {}
    local unique_client_names = {}

    for _, v in ipairs(buf_client_names) do
        if not hash[v] then
            if v ~= 'copilot' then
                unique_client_names[#unique_client_names + 1] = v
                hash[v] = true
            end
        end
    end
    local language_servers = table.concat(unique_client_names, ', ')

    return language_servers
end

local lsp = {
    function() return getLspName() end,
}

return {
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        dependencies = {
            'AndreM222/copilot-lualine',
        },
        opts = {
            options = {
                icons_enabled = false,
                theme = 'tokyonight',
                disabled_filetypes = { 'oil', 'DashboardLoaded', 'dashboard' },
                component_separators = '',
                section_separators = '',
            },
            extensions = { 'trouble' },
            sections = {
                lualine_a = { 'branch' },
                lualine_b = { 'filename' },
                lualine_c = { 'overseer' },
                lualine_x = {
                    lsp,
                    'copilot',
                    'progress',
                    { require('lazy.status').updates, cond = require('lazy.status').has_updates },
                    diff,
                    diagnostics,
                },
                lualine_y = {},
                lualine_z = {},
            },
        },
    },

    {
        'nvimdev/dashboard-nvim',
        lazy = false,
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
                    callback = function() require('lazy').show() end,
                })
            end

            return opts
        end,
    },

    {
        'stevearc/dressing.nvim',
        lazy = false,
        opts = {
            border = 'single',
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

    -- {
    --     'brenoprata10/nvim-highlight-colors',
    --     lazy = false,
    --     config = function()
    --         require('nvim-highlight-colors').setup {
    --             render = 'virtual',
    --             virtual_symbol = icons.misc.circle,
    --             enable_tailwind = true,
    --         }
    --     end,
    -- },

    {
        'lukas-reineke/indent-blankline.nvim',
        lazy = false,
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
                    'DashboardLoaded',
                    'dashboard',
                },
            },
        },
    },

    {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        lazy = false,
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons', -- optional dependency
        },
        config = function()
            require('barbecue').setup {
                create_autocmd = false, -- prevent barbecue from updating itself automatically
                theme = 'tokyonight',
                show_modified = true,
            }

            vim.api.nvim_create_autocmd({
                'WinScrolled',
                'BufWinEnter',
                'CursorHold',
                'InsertLeave',
                'BufModifiedSet',
            }, {
                group = vim.api.nvim_create_augroup('barbecue.updater', {}),
                callback = function() require('barbecue.ui').update() end,
            })
        end,
    },

    { 'karb94/neoscroll.nvim', lazy = false, config = true },
}
