{
    flake.modules.hjem.nvim-module = {lib, ...}: let
        inherit (import ./_helpers.nix {inherit lib;}) mkRaw;
    in {
        programs.nvim-module = {
            globals = {
                loaded_gzip = 1;
                did_install_default_menus = 1;
                loaded_tar = 1;
                loaded_tarPlugin = 1;
                loaded_zip = 1;
                loaded_zipPlugin = 1;
                loaded_getscript = 1;
                loaded_getscriptPlugin = 1;
                loaded_vimball = 1;
                loaded_vimballPlugin = 1;
                loaded_matchit = 1;
                loaded_2html_plugin = 1;
                loaded_rrhelper = 1;
                loaded_netrwPlugin = 1;
            };

            options = {
                autoread = true;
                mouse = "a";
                swapfile = false;
                switchbuf = "usetab";
                backup = false;
                writebackup = false;
                undofile = true;
                updatetime = 200;
                breakindent = true;
                cmdheight = 0;
                conceallevel = 2;
                cursorline = true;
                cursorlineopt = "screenline,number";
                hlsearch = true;
                laststatus = 2;
                number = true;
                relativenumber = false;
                ruler = false;
                scrolloff = 4;
                sidescrolloff = 8;
                shortmess = "aoOWFcSCs";
                showmatch = true;
                showmode = false;
                signcolumn = "yes:1";
                splitbelow = true;
                splitright = true;
                winborder = "single";
                wrap = false;
                listchars = "extends:…,nbsp:␣,precedes:…,tab:» ,trail:·";
                breakindentopt = "list:-1";
                autoindent = true;
                confirm = true;
                expandtab = true;
                formatoptions = "rqnl1j";
                ignorecase = true;
                inccommand = "split";
                incsearch = true;
                infercase = true;
                shiftwidth = 0;
                smartcase = true;
                smartindent = true;
                tabstop = 4;
                virtualedit = "block";
                foldenable = true;
                foldlevelstart = 99;
                foldmethod = "expr";
                foldcolumn = "1";
                foldtext = "";
                foldexpr = "v:lua.vim.treesitter.foldexpr()";
                fillchars = mkRaw ''{ fold = ' ', foldopen = ' ', foldclose = ' ', foldsep = ' ', foldinner = ' ', diff = ' ', eob = ' ' }'';
                verbose = 0;
                completeopt = "menuone,noinsert,popup,preview";
                spell = false;
                spelllang = "en_gb";
                spelloptions = "camel";
                wildmenu = true; 
                wildmode = "noselect:longest:lastused,full";
                spellfile = mkRaw "os.getenv('HOME') .. '/nix-config/modules/home/core/nvim/lua/spell/en.utf-8.add'";
                clipboard = "unnamedplus";
            };

            extraConfigPre = ''
                vim.opt.complete:remove('t')
            '';
        };
    };
}
