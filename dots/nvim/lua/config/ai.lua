require("codecompanion").setup({ strategies = { chat = { adapter = "anthropic" } } })

Util.map.nl("ac", vim.cmd.CodeCompanionChat, "AI chat")
