vim.cmd.packadd("render-markdown.nvim")
vim.schedule(function()
	require("render-markdown").buf_enable()
end)

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Conceal readonly markdown buffers",
	group = vim.api.nvim_create_augroup("readonly_markdown", { clear = true }),
	callback = function()
		if vim.bo.readonly or not vim.bo.modifiable then
			vim.opt_local.conceallevel = 3
			vim.opt_local.concealcursor = "n"
		end
	end,
})

vim.keymap.set("n", "<Leader>mp", function()
	if vim.opt_local.conceallevel == 3 then
		vim.opt_local.conceallevel = 1
		vim.opt_local.concealcursor = ""
	else
		vim.opt_local.conceallevel = 3
		vim.opt_local.concealcursor = "n"
		vim.opt_local.spell = false
	end
end, { buffer = true, desc = "Conceal markdown" })

vim.keymap.set("n", "<Leader>mP", function()
	local file = vim.fn.expand("%:p")
	if type(file) == "table" then
		return
	end
	vim.system({ "xdg-open", file }, function()
		return
	end)
end, { buffer = true, desc = "Open markdown in default app" })
