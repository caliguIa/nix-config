return {
    "nvim-neotest/neotest",
    dependencies = {
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-jest",
        "olimorris/neotest-phpunit",
        "nvim-neotest/nvim-nio",
    },
    opts = {},
    config = function()
        local neotest = require("neotest")

        vim.keymap.set("n", "<leader>trn", function()
            neotest.run.run()
        end, { desc = "[T]est [r]un [n]earest", silent = true })

        vim.keymap.set("n", "<leader>trf", function()
            neotest.run.run(vim.fn.expand("%"))
        end, { desc = "[T]est [r]un [f]ile", silent = true })

        vim.keymap.set("n", "<leader>tc", function()
            neotest.run.stop()
        end, { desc = "[T]est [c]ancel nearest", silent = true })

        vim.keymap.set("n", "<leader>ta", function()
            neotest.run.attach()
        end, { desc = "[T]est [a]ttach to nearest", silent = true })

        vim.keymap.set("n", "<leader>to", function()
            neotest.output.open()
        end, { desc = "[T]est [o]pen", silent = true })

        vim.keymap.set("n", "<leader>ts", function()
            neotest.summary.toggle()
        end, { desc = "[T]est [s]ummary", silent = true })

        vim.keymap.set("n", "<leader>tw", function()
            neotest.summary.toggle()
        end, { desc = "[T]est [w]atch", silent = true })

        vim.keymap.set("n", "t]", function()
            neotest.jump.next("Next test")
        end, { desc = "Jump to next [t]est", silent = true })

        vim.keymap.set("n", "[t", function()
            neotest.jump.prev("Previous test")
        end, { desc = "Jump to previous [t]est", silent = true })

        neotest.setup({
            adapters = {
                require("neotest-jest")({
                    jestCommand = "npm test --",
                    -- jestConfigFile = "config/jest.config.ts",
                    env = { CI = "true" },
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                }),
                require("neotest-phpunit")({
                    root_files = function()
                        return { "phpunit.xml" }
                    end,
                }),
            },
            diagnostic = {
                enabled = true,
            },
            icons = {
                failed = "✖",
                passed = "✔",
                running = "",
                skipped = "ﰸ",
            },
        })
    end,
}
