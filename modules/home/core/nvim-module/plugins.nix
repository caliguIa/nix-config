{
    flake.modules.hjem.nvim-module = {lib, ...}: let
        helpers = import ./_helpers.nix {inherit lib;};
        inherit (helpers) mkRaw;
    in {
        programs.nvim-module.plugins = {
            kanso = {
                src = "gh:webhooked/kanso.nvim";
                priority = 10;
                config = {
                    overrides = mkRaw ''
                        function(_colors)
                            return {
                                MiniJump = { link = 'MiniJump2dSpot' },
                                MatchParen = { link = 'MiniJump2dSpot' },
                            }
                        end
                    '';
                    background = {
                        dark = "mist";
                        light = "pearl";
                    };
                    minimal = true;
                };
                extraLua = ''
                    vim.o.background = 'dark'
                    vim.cmd.colorscheme('kanso')
                '';
            };

            "nvim.undotree" = {
                src = "nvim.undotree";
                name = "nvim.undotree";
                packadd = true;
            };

            oil = {
                src = "gh:stevearc/oil.nvim";
                config = {
                    lsp_file_methods = {autosave_changes = true;};
                    watch_for_changes = false;
                    keymaps = {
                        # Mixed positional+named Lua tables can't be modelled as a
                        # Nix attrset, so use mkRaw for those entries.
                        "g?" = mkRaw "{ 'actions.show_help', mode = 'n' }";
                        "<CR>" = "actions.select";
                        "<C-s>" = mkRaw "{ 'actions.select', opts = { vertical = true } }";
                        "<C-h>" = mkRaw "{ 'actions.select', opts = { horizontal = true } }";
                        "<C-t>" = mkRaw "{ 'actions.select', opts = { tab = true } }";
                        "<C-p>" = "actions.preview";
                        "q" = mkRaw "{ 'actions.close', mode = 'n' }";
                        "=" = "actions.refresh";
                        "-" = mkRaw "{ 'actions.parent', mode = 'n' }";
                        "_" = mkRaw "{ 'actions.open_cwd', mode = 'n' }";
                        "`" = mkRaw "{ 'actions.cd', mode = 'n' }";
                        "~" = mkRaw "{ 'actions.cd', opts = { scope = 'tab' }, mode = 'n' }";
                        "gs" = mkRaw "{ 'actions.change_sort', mode = 'n' }";
                        "gx" = "actions.open_external";
                        "g." = mkRaw "{ 'actions.toggle_hidden', mode = 'n' }";
                        "g\\" = mkRaw "{ 'actions.toggle_trash', mode = 'n' }";
                    };
                    view_options = {
                        show_hidden = true;
                        case_insensitive = true;
                    };
                };
                keymaps = [
                    {
                        lhs = "<leader>fe";
                        rhs = mkRaw "vim.cmd.Oil";
                        desc = "File explorer";
                    }
                ];
            };

            treesitter = {
                src = "gh:nvim-treesitter/nvim-treesitter";
                name = "nvim-treesitter";
                config = {};
                autocmds = [
                    {
                        event = "FileType";
                        group = "TreesitterSetup";
                        callback = mkRaw ''
                            function(ev)
                                if not ev.match or ev.match == ''' or ev.match == 'text' then vim.treesitter.stop() end
                                pcall(function() vim.treesitter.start() end)
                            end'';
                    }
                ];
            };
            ts-comments = {
                src = "gh:folke/ts-comments.nvim";
                name = "ts-comments";
                config = {};
            };
            timber = {
                src = "gh:Goose97/timber.nvim";
                config = {
                    log_templates = {
                        default = {php = mkRaw "[[dd('%log_target', %log_target);]]";};
                        plain = {php = mkRaw "[[dd(%insert_cursor);]]";};
                        batch_log_templates = {
                            default = {php = mkRaw "[[dd(%repeat<'%log_target', %log_target>);]]";};
                        };
                    };
                };
            };
            treesitter-context = {
                src = "gh:nvim-treesitter/nvim-treesitter-context";
                name = "treesitter-context";
                config = {max_lines = 4;};
            };
            nvim-ts-autotag = {
                src = "gh:windwp/nvim-ts-autotag";
                name = "nvim-ts-autotag";
                config = {};
            };

            conform = {
                src = "gh:stevearc/conform.nvim";
                config = {
                    formatters_by_ft = let
                        js = ["oxfmt"];
                    in {
                        lua = ["stylua"];
                        php = ["mago_format"];
                        typescript = js;
                        typescriptreact = js;
                        javascript = js;
                        javascriptreact = js;
                        css = js;
                        go = ["gofmt"];
                        html = js;
                        json = js;
                        jsonc = js;
                        markdown = js;
                        nix = ["alejandra"];
                        rust = ["rustfmt"];
                        scss = js;
                        toml = ["taplo"];
                        sql = mkRaw "{ 'sql_formatter', stop_after_first = true }";
                        mysql = ["sqruff"];
                        vue = js;
                        zig = ["zigfmt"];
                    };
                };
                autocmds = [
                    {
                        event = "BufWritePre";
                        group = "format-on-write";
                        callback = mkRaw "function(args) require('conform').format({ bufnr = args.buf, timeout_ms = 5000 }) end";
                    }
                ];
            };

            quicker = {
                src = "gh:stevearc/quicker.nvim";
                config = {};
                keymaps = [
                    {
                        lhs = "<leader>q";
                        rhs = mkRaw "function() require('quicker').toggle() end";
                        desc = "Toggle quickfix";
                        silent = false;
                    }
                    {
                        lhs = "<leader>u";
                        rhs = mkRaw "vim.cmd.Undotree";
                        desc = "Undotree";
                    }
                ];
            };

            neogit = {src = "gh:NeogitOrg/neogit";};
            blame = {src = "gh:FabijanZulj/blame.nvim";};
            conflict = {src = "gh:niekdomi/conflict.nvim";};
            diffs = {src = "gh:barrettruth/diffs.nvim";};
            diffview = {src = "gh:sindrets/diffview.nvim";};
            guh = {src = "gh:justinmk/guh.nvim";};

            aerial = {
                src = "gh:stevearc/aerial.nvim";
                config = {
                    open_automatic = false;
                    on_attach = mkRaw ''
                        function(bufnr)
                            vim.keymap.set('n', '{', vim.cmd.AerialPrev, { buffer = bufnr })
                            vim.keymap.set('n', '}', vim.cmd.AerialNext, { buffer = bufnr })
                        end'';
                    ignore = {
                        filetypes = [
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
                            "oil"
                        ];
                    };
                };
                keymaps = [
                    {
                        lhs = "<leader>co";
                        rhs = mkRaw "function() vim.cmd.AerialToggle('right') end";
                        desc = "Aerial";
                        silent = false;
                    }
                ];
            };

            lspconfig = {src = "gh:neovim/nvim-lspconfig";};
            zendiagram = {src = "cal:zendiagram.nvim";};

            mini = {src = "gh:nvim-mini/mini.nvim";};

            vim-test = {
                src = "gh:vim-test/vim-test";
                name = "vim-test";
            };
        };
    };
}
