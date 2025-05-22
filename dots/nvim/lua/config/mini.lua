local cmd = vim.cmd

local not_lua_diagnosing = function(notif) return not vim.startswith(notif.msg, "lua_ls: Diagnosing") end
local filterout_lua_diagnosing = function(notif_arr)
    return MiniNotify.default_sort(vim.tbl_filter(not_lua_diagnosing, notif_arr))
end
require("mini.notify").setup({
    content = { sort = filterout_lua_diagnosing },
    window = { config = { border = "none" } },
})
vim.notify = MiniNotify.make_notify()
Util.map.nl("N", MiniNotify.show_history, "Show notification history")

require("mini.icons").setup({
    use_file_extension = function(ext, _)
        local suf3, suf4 = ext:sub(-3), ext:sub(-4)
        return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
    end,
})
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()

require("mini.misc").setup()
MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
Util.map.nl("wm", MiniMisc.zoom, "Maximise window")

require("mini.files").setup({
    mappings = {
        go_in = "",
        go_in_plus = "<CR>",
        go_out = "",
        go_out_plus = "-",
    },
})
Util.map.nl("fe", function()
    local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
    MiniFiles.open(path)
end, "File explorer")

Util.au.cmd("User", {
    group = Util.au.group("mini_files_rename"),
    pattern = "MiniFilesActionRename",
    callback = function(event)
        local Methods = vim.lsp.protocol.Methods

        local changes = {
            files = {
                {
                    oldUri = vim.uri_from_fname(event.data.from),
                    newUri = vim.uri_from_fname(event.data.to),
                },
            },
        }
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
            if client:supports_method(Methods.workspace_willRenameFiles) then
                print(client.name)
                local resp = client:request_sync(Methods.workspace_willRenameFiles, changes, 1000, 0)
                if resp and resp.result ~= nil then
                    vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
                end
                if client:supports_method(Methods.workspace_didRenameFiles) then
                    client:notify(Methods.workspace_didRenameFiles, changes)
                end
            end
        end
    end,
})

require("mini.extra").setup()
require("mini.visits").setup()
local function goto_marked_file(index)
    local marked = MiniVisits.list_paths(nil, {
        filter = "core",
        sort = function(paths) return paths end,
    })
    if marked[index] then cmd.edit(marked[index]) end
end
Util.map.n("ma", function() MiniVisits.add_label("core") end, "Add mark")
Util.map.n("md", function() MiniVisits.remove_label("core") end, "Delete mark")
Util.map.n("mq", function() goto_marked_file(1) end, "Goto mark 1")
Util.map.n("mw", function() goto_marked_file(2) end, "Goto mark 2")
Util.map.n("me", function() goto_marked_file(3) end, "Goto mark 3")
Util.map.n("mr", function() goto_marked_file(4) end, "Goto mark 4")

require("mini.pick").setup()
vim.ui.select = MiniPick.ui_select
-- Util.map.nl("gb", function() cmd.Pick("git_branches") end, "Branches")
Util.map.nl("sm", function() cmd.Pick("visit_paths", 'filter="core"') end, "Marked files")
Util.map.nl("cs", function() cmd.Pick("spellsuggest") end, "Spelling")
Util.map.nl("sf", function() cmd.Pick("files") end, "Find Files")
Util.map.nl("sg", function() cmd.Pick("grep_live") end, "Grep")
Util.map.nl("sG", function() cmd.Pick("grep", "pattern='<cword>'") end, "Grep current word")
Util.map.nl("sh", function() cmd.Pick("help") end, "Help Pages")
Util.map.nl("sH", function() cmd.Pick("hl_groups") end, "Highlight groups")
Util.map.nl("sk", function() cmd.Pick("keymaps") end, "Keymaps")
Util.map.nl("sr", function() cmd.Pick("resume") end, "Resume")
Util.map.nl("so", function() cmd.Pick("visit_paths") end, "Recent")

Util.map.nl("sb", function()
    MiniPick.builtin.buffers({ include_current = false }, {
        mappings = {
            wipeout = {
                char = "<C-d>",
                func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
            },
        },
    })
end, "Buffers")

require("mini.bufremove").setup()
Util.map.nl("bd", function() MiniBufremove.delete(vim.api.nvim_get_current_buf()) end, "Delete current")
Util.map.nl("bo", function()
    local current_buf = vim.api.nvim_get_current_buf()
    local all_bufs = vim.api.nvim_list_bufs()

    for _, buf in ipairs(all_bufs) do
        -- Skip the current buffer and non-listed/invalid buffers
        if buf ~= current_buf and vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_is_valid(buf) then
            MiniBufremove.delete(buf, true) -- Using force=true to skip confirmation
        end
    end
end, "Delete others")

require("mini.surround").setup()

local statusline = require("mini.statusline")
statusline.setup({
    content = {
        active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
                { hl = mode_hl, strings = { mode } },
                { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
                "%<", -- Mark general truncate point
                { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
                "%=", -- End left alignment
                { hl = "MiniStatuslineDevinfo", strings = { lsp } },
                { hl = "MiniStatuslineDevinfo", strings = { fileinfo } },
                { hl = mode_hl, strings = { search, location } },
            })
        end,
        inactive = function()
            return MiniStatusline.combine_groups({
                { hl = "MiniStatuslineDevinfo", strings = { "" } },
            })
        end,
    },
})
statusline.section_fileinfo = function() return vim.bo.filetype end
statusline.section_location = function() return "%p%% %L" end

local ai = require("mini.ai")
ai.setup({
    n_lines = 500,
    custom_textobjects = {
        B = MiniExtra.gen_ai_spec.buffer(),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
        F = ai.gen_spec.function_call(),
    },
})

local miniclue = require("mini.clue")
miniclue.setup({
    clues = {
        {
            { mode = "n", keys = "<Leader>a", desc = "+AI" },
            { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
            { mode = "n", keys = "<Leader>c", desc = "+Code" },
            { mode = "n", keys = "<Leader>d", desc = "+DB" },
            { mode = "n", keys = "<Leader>f", desc = "+File" },
            { mode = "n", keys = "<Leader>g", desc = "+Git" },
            { mode = "n", keys = "<Leader>l", desc = "+Laravel" },
            { mode = "n", keys = "m", desc = "+Marks" },
            { mode = "n", keys = "<Leader>r", desc = "+Rename" },
            { mode = "n", keys = "<Leader>s", desc = "+Search" },
            { mode = "n", keys = "<Leader>t", desc = "+Test" },
            { mode = "n", keys = "<Leader>w", desc = "+Window" },
            { mode = "n", keys = "<Leader><tab>", desc = "+Tabs" },
        },
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.windows({ submode_resize = true }),
        miniclue.gen_clues.z(),
    },
    triggers = {
        { mode = "n", keys = "<Leader>" }, -- Leader triggers
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = [[\]] }, -- mini.basics
        { mode = "n", keys = "[" }, -- mini.bracketed
        { mode = "n", keys = "]" },
        { mode = "n", keys = "g" }, -- `g` key
        { mode = "n", keys = "s" }, -- mini.surround
        { mode = "v", keys = "s" }, -- mini.surround
        { mode = "n", keys = "w" }, -- mini.windows
        { mode = "n", keys = "<C-w>" }, -- Window commands
        { mode = "n", keys = "z" }, -- `z` key
    },
    window = { config = { border = "none" } },
})

require("mini.pairs").setup({
    modes = { insert = true, command = false, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
    mappings = {
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
        ["("] = { action = "open", pair = "()", neigh_pattern = ".[%s%z%)]", register = { cr = false } },
        ["["] = { action = "open", pair = "[]", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
        ["<"] = { action = "open", pair = "<>", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
    },
})

require("mini.completion").setup({
    lsp_completion = { source_func = "omnifunc", auto_setup = false },
})
Util.au.cmd("LspAttach", {
    group = Util.au.group("lsp-attach-mini-comp"),
    callback = function(args) vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp" end,
})
vim.lsp.config("*", {
    capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        MiniCompletion.get_lsp_capabilities()
    ),
})

require("mini.diff").setup({
    view = {
        style = "sign",
        signs = { add = "▎", change = "▎", delete = "" },
    },
})
Util.map.nl("go", function() MiniDiff.toggle_overlay(0) end, "Diff overlay")

-- require("mini.git").setup()
-- Util.map.nl("gB", function()
--     vim.cmd("vertical leftabove Git blame -- %")
--     vim.cmd("vertical resize 30%")
--     vim.opt_local.winbar = " " -- Empty winbar for padding
-- end, "Blame")
-- local align_blame = function(au_data)
--     if au_data.data.git_subcommand ~= "blame" then return end
--
--     local win_src = au_data.data.win_source
--     vim.wo.wrap = false
--     vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
--     vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
--
--     vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
-- end
--
-- Util.au.cmd("User", { pattern = "MiniGitCommandSplit", callback = align_blame })

require("mini.snippets").setup({
    snippets = {
        require("mini.snippets").gen_loader.from_lang(),
    },
})
local function highlight(group, opts) vim.api.nvim_set_hl(0, group, opts) end
highlight("MiniSnippetsCurrent", { force = true })
highlight("MiniSnippetsCurrentReplace", { force = true })
highlight("MiniSnippetsFinal", { force = true })
highlight("MiniSnippetsUnvisited", { force = true })
highlight("MiniSnippetsVisited", { force = true })

require("mini.jump").setup()
require("mini.jump2d").setup({
    view = { dim = true },
    allowed_windows = { not_current = false },
    allowed_lines = {
        blank = false,
        fold = false,
    },
    silent = true,
})
