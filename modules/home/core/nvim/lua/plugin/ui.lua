vim.schedule(function()
    local ui2 = require('vim._core.ui2')
    ui2.enable({
        enable = true,
        msg = {
            height = 0.3,
            timeout = 5000,
            targets = {
                [''] = 'msg',
                empty = 'msg',
                bufwrite = 'msg',
                confirm = 'msg',
                emsg = 'msg',
                echo = 'msg',
                echomsg = 'msg',
                echoerr = 'msg',
                completion = 'msg',
                list_cmd = 'msg',
                lua_error = 'msg',
                lua_print = 'msg',
                progress = 'msg',
                rpc_error = 'msg',
                quickfix = 'msg',
                search_cmd = 'msg',
                search_count = 'msg',
                shell_cmd = 'msg',
                shell_err = 'msg',
                shell_out = 'msg',
                shell_ret = 'msg',
                undo = 'msg',
                verbose = 'msg',
                wildlist = 'msg',
                wmsg = 'msg',
                typed_cmd = 'msg',
            },
        },
    })

    local orig_set_pos = ui2.msg.set_pos
    ---@diagnostic disable-next-line: duplicate-set-field
    ui2.msg.set_pos = function(tgt)
        orig_set_pos(tgt)
        if (tgt == 'msg' or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
            pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
                relative = 'editor',
                anchor = 'NE',
                row = 0,
                col = vim.o.columns,
            })
        end
    end
end)
