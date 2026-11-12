{
    flake.modules.nixos.core =
        { pkgs, ... }:
        let
            # mirrors modules/system/core/nvim/lua/colors/noir.lua
            c = {
                noir_0 = "#eeeeee";
                noir_1 = "#e4e4e4";
                noir_2 = "#a4a7a4";
                noir_3 = "#b2b2b2";
                noir_4 = "#9e9e9e";
                noir_5 = "#8a8a8a";
                noir_6 = "#767676";
                noir_7 = "#585858";
                noir_8 = "#444444";
                noir_9 = "#303030";
                noir_10 = "#1c1c1c";
                noir_11 = "#121212";
                red = "#c4746e";
                red_bright = "#e46876";
                red_git = "#c34043";
                yellow_bright = "#e6c384";
                yellow_git = "#dca561";
                green = "#76946a";
                green_bright = "#98bb6c";
                blue = "#658594";
                blue_bright = "#9edaed";
            };
            bg = c.noir_11;
            primary = c.blue_bright;
            popupBorder = c.noir_7;

            # Square status bar, tabs and hover caps (defaults are powerline half-circles).
            # Popup borders are hardcoded rounded in yazi; no option reaches them.
            flat = {
                open = "";
                close = "";
            };
        in
        {
            programs.fish.interactiveShellInit = ''
                # yazi, then cd to wherever it quit (q); Q quits without moving
                function y
                    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
                    command yazi $argv --cwd-file="$tmp"
                    if read -z cwd < "$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
                        builtin cd -- "$cwd"
                    end
                    rm -f -- "$tmp"
                end
            '';

            programs.yazi = {
                enable = true;
                package = pkgs.yazi.override {
                    extraPackages = [ pkgs.mediainfo ];
                };
                plugins = {
                    inherit (pkgs.yaziPlugins) git mediainfo;
                    tab-close = ./tab-close.yazi;
                };
                initLua = ./init.lua;

                settings.yazi = {
                    mgr = {
                        ratio = [
                            1
                            3
                            4
                        ];
                        show_hidden = true;
                        sort_by = "natural";
                        sort_dir_first = true;
                        linemode = "size_mtime"; # init.lua
                        scrolloff = 4;
                    };
                    plugin = {
                        prepend_fetchers = [
                            {
                                url = "*";
                                run = "git";
                                group = "git";
                            }
                            {
                                url = "*/";
                                run = "git";
                                group = "git";
                            }
                        ];
                        # Thumbnail plus mediainfo metadata in the preview pane.
                        prepend_preloaders = [
                            {
                                mime = "{audio,video,image}/*";
                                run = "mediainfo";
                            }
                            {
                                mime = "application/subrip";
                                run = "mediainfo";
                            }
                        ];
                        prepend_previewers = [
                            {
                                mime = "{audio,video,image}/*";
                                run = "mediainfo";
                            }
                            {
                                mime = "application/subrip";
                                run = "mediainfo";
                            }
                        ];
                    };
                };

                # Defaults are already vim (hjkl, gg/G, C-u/C-d, v/V, /, n/N, y/x/p).
                # Esc never quits; drop the one other non-q exit. <C-c> was also the only
                # tab close, so `t c` (beside `t t` new / `t r` rename) takes that over.
                settings.keymap.mgr.prepend_keymap = [
                    {
                        on = "<C-c>";
                        run = "escape";
                        desc = "Exit visual mode, clear selection, or cancel search";
                    }
                    {
                        on = [
                            "t"
                            "c"
                        ];
                        run = "plugin tab-close";
                        desc = "Close current tab";
                    }
                ];

                settings.theme = {
                    mgr = {
                        cwd.fg = primary;
                        find_keyword = {
                            fg = c.red_bright;
                            bold = true;
                            underline = true;
                        };
                        find_position = {
                            fg = c.noir_5;
                            italic = true;
                        };
                        symlink_target = {
                            fg = c.noir_6;
                            italic = true;
                        };
                        marker_copied = {
                            fg = c.green_bright;
                            bg = c.green_bright;
                        };
                        marker_cut = {
                            fg = c.red_bright;
                            bg = c.red_bright;
                        };
                        marker_marked = {
                            fg = primary;
                            bg = primary;
                        };
                        marker_selected = {
                            fg = c.yellow_bright;
                            bg = c.yellow_bright;
                        };
                        count_copied = {
                            fg = bg;
                            bg = c.green_bright;
                        };
                        count_cut = {
                            fg = bg;
                            bg = c.red_bright;
                        };
                        count_selected = {
                            fg = bg;
                            bg = c.yellow_bright;
                        };
                        border_symbol = "│";
                        border_style.fg = c.noir_9;
                        # the bat theme; yazi takes only foregrounds from it
                        syntect_theme = "${../bat/themes/kanso-zen.tmTheme}";
                    };

                    tabs = {
                        active = {
                            fg = bg;
                            bg = c.noir_3;
                            bold = true;
                        };
                        inactive = {
                            fg = c.noir_5;
                            bg = c.noir_9;
                        };
                        sep_inner = flat;
                        sep_outer = flat;
                    };

                    mode = {
                        normal_main = {
                            fg = bg;
                            bg = primary;
                            bold = true;
                        };
                        normal_alt = {
                            fg = c.noir_3;
                            bg = c.noir_9;
                        };
                        select_main = {
                            fg = bg;
                            bg = c.yellow_bright;
                            bold = true;
                        };
                        select_alt = {
                            fg = c.yellow_bright;
                            bg = c.noir_9;
                        };
                        unset_main = {
                            fg = bg;
                            bg = c.red_bright;
                            bold = true;
                        };
                        unset_alt = {
                            fg = c.red_bright;
                            bg = c.noir_9;
                        };
                    };

                    indicator = {
                        parent = {
                            fg = c.noir_0;
                            bg = c.noir_10;
                        };
                        current = {
                            fg = c.noir_0;
                            bg = c.noir_9;
                        };
                        preview = {
                            fg = c.noir_0;
                            bg = c.noir_10;
                        };
                        # Plain gutter cells either side of the hover bar instead of half-circle caps.
                        padding = {
                            open = " ";
                            close = " ";
                        };
                    };

                    status = {
                        sep_left = flat;
                        sep_right = flat;
                        perm_sep.fg = c.noir_7;
                        perm_type.fg = c.green_bright;
                        perm_read.fg = c.yellow_bright;
                        perm_write.fg = c.red;
                        perm_exec.fg = primary;
                        progress_label = {
                            fg = c.noir_0;
                            bold = true;
                        };
                        progress_normal = {
                            fg = c.green;
                            bg = c.noir_9;
                        };
                        progress_error = {
                            fg = c.yellow_bright;
                            bg = c.red_git;
                        };
                    };

                    which = {
                        border.fg = popupBorder;
                        mask.bg = c.noir_10;
                        cand.fg = primary;
                        rest.fg = c.noir_7;
                        desc.fg = c.noir_4;
                        separator_style.fg = c.noir_7;
                    };

                    confirm = {
                        border.fg = popupBorder;
                        title.fg = c.noir_0;
                        btn_yes = {
                            fg = bg;
                            bg = primary;
                        };
                        btn_no.fg = c.noir_4;
                    };

                    spot = {
                        border.fg = popupBorder;
                        title.fg = c.noir_0;
                        tbl_col.fg = primary;
                        tbl_cell = {
                            fg = c.noir_0;
                            bg = c.noir_9;
                        };
                    };

                    notify = {
                        title_info.fg = c.green_bright;
                        title_warn.fg = c.yellow_bright;
                        title_error.fg = c.red;
                    };

                    pick = {
                        border.fg = popupBorder;
                        active = {
                            fg = primary;
                            bold = true;
                        };
                        inactive.fg = c.noir_4;
                    };

                    input = {
                        border.fg = popupBorder;
                        title.fg = c.noir_0;
                        value.fg = c.noir_1;
                        selected.bg = c.noir_9;
                    };

                    cmp = {
                        border.fg = popupBorder;
                        active = {
                            fg = c.noir_0;
                            bg = c.noir_7;
                        };
                        inactive.fg = c.noir_4;
                    };

                    tasks = {
                        border.fg = popupBorder;
                        title.fg = c.noir_0;
                        hovered = {
                            fg = primary;
                            bold = true;
                        };
                    };

                    help = {
                        border.fg = popupBorder;
                        chord.fg = primary;
                        action.fg = c.noir_4;
                        hovered = {
                            fg = c.noir_0;
                            bg = c.noir_9;
                            bold = true;
                        };
                    };

                    # Matches the Added/Changed/Removed groups in nvim.
                    git = {
                        ignored.fg = c.noir_7;
                        untracked.fg = c.noir_5;
                        unstaged.fg = c.yellow_git;
                        staged.fg = c.green;
                        added.fg = c.green;
                        deleted.fg = c.red_git;
                        updated.fg = c.yellow_git;
                    };

                    filetype.rules = [
                        {
                            url = "*";
                            is = "orphan";
                            fg = c.red_bright;
                        }
                        {
                            url = "*";
                            is = "dummy";
                            fg = c.red_bright;
                        }
                        {
                            url = "*/";
                            is = "dummy";
                            fg = c.red_bright;
                        }
                        {
                            url = "*";
                            is = "exec";
                            fg = c.green_bright;
                        }
                        {
                            mime = "**/image/*";
                            fg = c.yellow_bright;
                        }
                        {
                            mime = "**/{audio,video}/*";
                            fg = c.red_bright;
                        }
                        {
                            mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
                            fg = c.red;
                        }
                        {
                            mime = "**/application/{pdf,doc,rtf}";
                            fg = c.blue;
                        }
                        {
                            mime = "vfs/{absent,stale}";
                            fg = c.noir_7;
                        }
                        {
                            url = "*/";
                            fg = c.noir_3;
                            bold = true;
                        }
                        {
                            url = "*";
                            fg = c.noir_2;
                        }
                    ];
                };
            };
        };
}
