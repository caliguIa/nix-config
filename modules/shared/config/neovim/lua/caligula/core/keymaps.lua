local keymap = vim.keymap

keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- FileTree keymaps
keymap.set({ "n", "v" }, "<leader>fe", "<CMD>Oil<CR>", { silent = true, desc = "Toggle [F]ile [E]xplorer" })

-- Git keymaps
keymap.set({ "n" }, "<leader>G", "<CMD>Git<CR>", { silent = true, desc = "Open [G]it" })
keymap.set({ "n" }, "<leader>gB", "<CMD>Git blame<CR>", { silent = true, desc = "Open [G]it [B]lame" })

-- Remap for dealing with word wrap
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
