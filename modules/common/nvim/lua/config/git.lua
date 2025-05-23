require("git-conflict").setup()
-- require("neogit").setup()

Util.map.nl("gg", vim.cmd.Git, "Git")
Util.map.nl("gf", function() vim.cmd.Git("fetch --all") end, "Fetch")
Util.map.nl("gp", function() vim.cmd.Git("pull") end, "Pull")
Util.map.nl("gP", function() vim.cmd.Git("push") end, "Push")
Util.map.nl("gb", function() vim.cmd.Git("blame") end, "Blame")
