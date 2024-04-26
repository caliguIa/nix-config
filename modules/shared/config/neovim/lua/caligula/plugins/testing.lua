local test_icons = require('caligula.core.icons').test

return {
    {
        'nvim-neotest/neotest',
        dependencies = {
            'antoinemadec/FixCursorHold.nvim',
            'nvim-neotest/neotest-jest',
            'olimorris/neotest-phpunit',
            'nvim-neotest/nvim-nio',
        },
        opts = {
            adapters = {
                ['neotest-jest'] = function()
                    require('neotest-jest').adapter {
                        jestCommand = 'npm test --',
                        -- jestConfigFile = "config/jest.config.ts",
                        env = { CI = 'true' },
                        cwd = function()
                            return vim.fn.getcwd()
                        end,
                    }
                end,
                ['neotest-phpunit'] = function()
                    require('neotest-phpunit').adapter {
                        root_files = { 'composer.json', 'phpunit.xml', '.gitignore' },
                    }
                end,
            },
            diagnostic = {
                enabled = true,
            },
            icons = {
                failed = test_icons.failed,
                passed = test_icons.passed,
                running = test_icons.running,
                skipped = test_icons.skipped,
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>trn", function() require("neotest").run.run() end, desc = "[T]est [r]un [n]earest" },

            { "<leader>trf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "[T]est [r]un [f]ile" },

            { "<leader>tc", function() require("neotest").run.stop() end, desc = "[T]est [c]ancel nearest" },

            { "<leader>ta", function() require("neotest").run.attach() end, desc = "[T]est [a]ttach to nearest" },

            { "<leader>to", function() require("neotest").output.open() end, desc = "[T]est [o]pen" },

            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "[T]est [s]ummary" },

            { "<leader>tw", function() require("neotest").summary.toggle() end, desc = "[T]est [w]atch" },

            { "t]", function() require("neotest").jump.next("Next test") end, desc = "Jump to next [t]est" },

            { "[t", function() require("neotest").jump.prev("Previous test") end, desc = "Jump to previous [t]est" },
        },
    },
}
