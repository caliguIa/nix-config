{
    flake.modules.hjem.nvim-module = {lib, ...}: let
        inherit (import ./_helpers.nix {inherit lib;}) mkRaw;
    in {
        # Ported from plugin/autocmds.lua.
        programs.nvim-module.autocmds = [
            {
                event = ["FocusGained" "TermClose" "TermLeave"];
                desc = "Reload file if changed";
                group = "checktime";
                callback = mkRaw ''
                    function()
                        if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
                    end'';
            }
            {
                event = "TextYankPost";
                desc = "Highlight on yank";
                group = "highlight_yank";
                callback = mkRaw "function() vim.hl.hl_op({ higroup = 'Visual', timeout = 300 }) end";
            }
            {
                event = "FileType";
                desc = "Close certain filetypes with <q>";
                group = "close_with_q";
                pattern = [
                    "checkhealth"
                    "dbout"
                    "git"
                    "help"
                    "lspinfo"
                    "qf"
                    "fugitive"
                    "notify"
                    "startuptime"
                    "tsplayground"
                    "fugitiveblame"
                    "sqls_output"
                ];
                callback = mkRaw ''
                    function(event)
                        vim.bo[event.buf].buflisted = false
                        vim.schedule(function()
                            vim.keymap.set(
                                'n',
                                'q',
                                function() pcall(vim.api.nvim_buf_delete, event.buf, { force = true }) end,
                                { desc = 'Close buffer', silent = true, buffer = event.buf }
                            )
                        end)
                    end'';
            }
            {
                event = "BufWinEnter";
                desc = "Open help buffers in a vsplit";
                group = "help_window_right";
                pattern = ["*.txt"];
                callback = mkRaw ''
                    function()
                        if vim.o.filetype == 'help' then vim.cmd.wincmd('L') end
                    end'';
            }
            {
                event = "LspProgress";
                callback = mkRaw ''
                    function(ev)
                        local client = vim.lsp.get_client_by_id(ev.data.client_id)
                        if not client then return end
                        local value = ev.data.params.value
                        if not value.kind == 'end' then return end
                        local msg = ('[%s] %s %s'):format(client.name, '✓', value.title or ''')
                        vim.notify(msg)
                    end'';
            }
            {
                event = "FileType";
                pattern = "msg";
                callback = mkRaw ''
                    function()
                        local ui2 = require('vim._core.ui2')
                        local win = ui2.wins and ui2.wins.msg
                        if win and vim.api.nvim_win_is_valid(win) then
                            vim.api.nvim_set_option_value(
                                'winhighlight',
                                'Normal:NormalFloat,FloatBorder:FloatBorder',
                                { scope = 'local', win = win }
                            )
                        end
                    end'';
            }
        ];
    };
}
