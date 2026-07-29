{
    flake.modules.hjem.nvim-module = {lib, ...}: let
        inherit (import ./_helpers.nix {inherit lib;}) mkRaw;
    in {
        # Ported from plugin/keymaps.lua.
        programs.nvim-module.keymaps = [
            {
                mode = ["i" "v" "x"];
                lhs = "<C-[>";
                rhs = "<Esc>";
                desc = "Exit mode";
            }
            {
                lhs = "<leader>X";
                rhs = mkRaw "function() vim.cmd('!chmod +x %') end";
                desc = "Make file executable";
            }
            {
                lhs = "<C-d>";
                rhs = "<C-d>zz";
                desc = "Down half-page and center";
            }
            {
                lhs = "<C-u>";
                rhs = "<C-u>zz";
                desc = "Up half-page and center";
            }
            {
                lhs = "<esc>";
                rhs = mkRaw "vim.cmd.noh";
                desc = "Escape and clear hlsearch";
            }
            {
                mode = "x";
                lhs = "/";
                rhs = "<Esc>/\\%V";
            }
            {
                lhs = "n";
                rhs = "'Nn'[v:searchforward].'zv'";
                desc = "Next Search Result";
                expr = true;
            }
            {
                lhs = "N";
                rhs = "'nN'[v:searchforward].'zv'";
                desc = "Prev Search Result";
                expr = true;
            }
            {
                mode = "i";
                lhs = ",";
                rhs = ",<c-g>u";
                desc = "Comma add undo break-point";
            }
            {
                mode = "i";
                lhs = ".";
                rhs = ".<c-g>u";
                desc = "Period add undo break-point";
            }
            {
                mode = "i";
                lhs = ";";
                rhs = ";<c-g>u";
                desc = "Semi-colon add undo break-point";
            }
            {
                mode = "v";
                lhs = "<";
                rhs = "<gv";
                desc = "Dedent reselect";
            }
            {
                mode = "v";
                lhs = ">";
                rhs = ">gv";
                desc = "Indent reselect";
            }
            {
                lhs = "<leader>wd";
                rhs = "<C-W>c";
                desc = "Delete Window";
                remap = true;
            }
            {
                lhs = "<leader>w";
                rhs = "<c-w>";
                desc = "Windows";
                remap = true;
            }
            {
                lhs = "<tab>]";
                rhs = mkRaw "vim.cmd.tabnext";
                desc = "Next";
            }
            {
                lhs = "<tab>[";
                rhs = mkRaw "vim.cmd.tabprevious";
                desc = "Previous";
            }
            {
                lhs = "<tab>d";
                rhs = mkRaw "vim.cmd.tabclose";
                desc = "Close current";
            }
            {
                lhs = "<tab>o";
                rhs = mkRaw "vim.cmd.tabonly";
                desc = "Close other";
            }
            {
                lhs = "<leader>ba";
                rhs = mkRaw "function() vim.cmd.b('#') end";
                desc = "Alternate";
            }
            {
                lhs = "<leader>cS";
                rhs = mkRaw ''
                    function()
                        vim.o.spell = not vim.o.spell
                        vim.notify('spell ' .. (vim.wo.spell and 'on' or 'off'))
                    end'';
                desc = "Alternate";
            }
            {
                lhs = "j";
                rhs = "gj";
                desc = "Navigate through wrapped lines";
            }
            {
                lhs = "k";
                rhs = "gk";
                desc = "Navigate through wrapped lines";
            }
        ];
    };
}
