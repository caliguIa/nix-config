local test_icons = require('caligula.core.icons').test

return {
    'nvim-neotest/neotest',
    lazy = true,
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        'olimorris/neotest-phpunit',
        'nvim-neotest/neotest-jest',
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('neotest').setup {
            adapters = {
                require 'neotest-phpunit',
                require 'neotest-jest' {
                    cwd = '/Users/caligula/oneupsales/platform/resources/client',
                    jestCommand = 'npm test --',
                },
            },
            icons = {
                failed = test_icons.failed,
                passed = test_icons.passed,
                running = test_icons.running,
                skipped = test_icons.skipped,
            },
        }
    end,
    -- stylua: ignore
    keys = {
        { "<leader>tr", function() require("neotest").run.run() end, desc = "[T]est [r]un nearest" },

        { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "[T]est [R]un file" },

        { "<leader>tc", function() require("neotest").run.stop() end, desc = "[T]est [c]ancel nearest" },

        { "<leader>ta", function() require("neotest").run.attach() end, desc = "[T]est [a]ttach to nearest" },

        { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "[T]est [o]utput open" },

        { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "[T]est [O]utput panel" },

        { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "[T]est [s]ummary" },

        { "<leader>tw", function() require("neotest").summary.toggle() end, desc = "[T]est [w]atch" },

        { "]t", function() require("neotest").jump.next({status = 'failed'}) end, desc = "Jump to next failed [t]est" },

        { "[t", function() require("neotest").jump.prev({status = 'failed'}) end, desc = "Jump to previous failed [t]est" },
    },
}
