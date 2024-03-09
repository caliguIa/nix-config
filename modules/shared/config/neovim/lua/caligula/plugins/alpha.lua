return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- dashboard.section.header.val = {
        --     "                                                     ",
        --     "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        --     "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        --     "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        --     "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        --     "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        --     "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        --     "                                                     ",
        -- }
        dashboard.section.header.val = {
            "                                                                ",
            "                                          ▄▄                    ",
            "                                          ██                    ",
            "                                                                ",
            " ▀████████▄   ▄▄█▀██  ▄██▀██▄▀██▀   ▀██▀▀███ ▀████████▄█████▄   ",
            "   ██    ██  ▄█▀   ████▀   ▀██ ██   ▄█    ██   ██    ██    ██   ",
            "   ██    ██  ██▀▀▀▀▀▀██     ██  ██ ▄█     ██   ██    ██    ██   ",
            "   ██    ██  ██▄    ▄██▄   ▄██   ███      ██   ██    ██    ██   ",
            " ▄████  ████▄ ▀█████▀ ▀█████▀     █     ▄████▄████  ████  ████▄ ",
            "                                                                ",
        }

        dashboard.section.buttons.val = {
            dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
            dashboard.button("<Leader> fe", "  > Toggle file explorer", "<CMD>Oil<CR>"),
            dashboard.button("<Leader> sf", "󰱼  > Search files", "<cmd>Telescope find_files<CR>"),
            dashboard.button("<Leader> sg", "  > Search grep", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("q", "  > Quit neovim", "<cmd>qa<CR>"),
        }

        alpha.setup(dashboard.opts)

        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
