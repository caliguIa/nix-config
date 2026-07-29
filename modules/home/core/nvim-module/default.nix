{inputs, ...}: {
    flake.modules.hjem.nvim-module = {
        config,
        pkgs,
        lib,
        ...
    }: let
        inherit (lib) mkOption mkEnableOption types mkIf;
        inherit (lib.meta) getExe;
        inherit (lib.strings) makeBinPath;

        # Nix -> Lua via nixpkgs' native serializer. mkLuaInline wraps a string
        # so it is emitted as a verbatim Lua expression (functions, cmd refs).
        toLua = lib.generators.toLua {};
        mkRaw = lib.generators.mkLuaInline;

        helpers = import ./_helpers.nix {inherit lib;};
        inherit (helpers) keymapExpr autocmdExpr;

        cfg = config.programs.nvim-module;

        # Neovim binary, reused from the nightly overlay (same as the live
        # config). wrapRc = false so it reads an external init.lua.
        tools = with pkgs; [
            tree-sitter
            gcc
        ];

        neovim = pkgs.wrapNeovimUnstable inputs.nvim-nightly.packages.${pkgs.stdenvNoCC.system}.neovim {
            withNodeJs = false;
            withPython3 = false;
            withRuby = false;
            wrapRc = false;
            wrapperArgs = ["--suffix" "PATH" ":" (makeBinPath tools)];
        };

        # `nvim-module` launcher: NVIM_APPNAME makes neovim read the sibling
        # ~/.config/nvim-module directory instead of ~/.config/nvim.
        launcher = pkgs.writeShellApplication {
            name = "nvim-module";
            text = ''NVIM_APPNAME=nvim-module exec ${getExe neovim} "$@"'';
        };

        keymapModule = {
            options = {
                mode = mkOption {
                    type = types.either types.str (types.listOf types.str);
                    default = "n";
                    description = "Mode(s) passed to vim.keymap.set.";
                };
                lhs = mkOption {
                    type = types.str;
                    description = "Left-hand side (the key sequence).";
                };
                rhs = mkOption {
                    # String => literal rhs. Use lib.lua.mkRaw for a function or
                    # expression (cmd refs, callbacks).
                    type = types.either types.str types.attrs;
                    description = "Right-hand side: a string, or mkRaw for a Lua function/expression.";
                };
                desc = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Mapping description.";
                };
                silent = mkOption {
                    type = types.bool;
                    default = true;
                };
                expr = mkOption {
                    type = types.bool;
                    default = false;
                };
                remap = mkOption {
                    type = types.bool;
                    default = false;
                };
                buffer = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Buffer-local mapping (opts.buffer = true). Useful for plugin/ftplugin keymaps.";
                };
                opts = mkOption {
                    # Extra opts merged into the opts table (freeform, mkRaw ok).
                    type = types.attrs;
                    default = {};
                    description = "Additional options merged into the vim.keymap.set opts table.";
                };
            };
        };

        autocmdModule = {
            options = {
                event = mkOption {
                    type = types.either types.str (types.listOf types.str);
                    description = "Event(s) for nvim_create_autocmd.";
                };
                group = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Augroup name. Created (clear = true) automatically if set.";
                };
                pattern = mkOption {
                    type = types.nullOr (types.either types.str (types.listOf types.str));
                    default = null;
                };
                desc = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                };
                callback = mkOption {
                    # mkRaw with a Lua function; mutually used with `command`.
                    type = types.nullOr types.attrs;
                    default = null;
                    description = "Lua callback (use lib.lua.mkRaw \"function(ev) ... end\").";
                };
                command = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Ex command string (alternative to callback).";
                };
            };
        };

        ftpluginModule = {
            options = {
                settings = mkOption {
                    type = types.attrsOf types.anything;
                    default = {};
                    description = "vim.opt_local settings. Each key => vim.opt_local[key] = value.";
                };
                extraLua = mkOption {
                    type = types.nullOr types.lines;
                    default = null;
                    description = "Verbatim Lua appended to the generated ftplugin file.";
                };
            };
        };

        lspServerModule = {
            options = {
                enable = mkOption {
                    type = types.bool;
                    default = true;
                    description = "Whether to vim.lsp.enable this server.";
                };
                settings = mkOption {
                    # The vim.lsp.Config table returned from after/lsp/<name>.lua.
                    # mkRaw leaves allowed for functions (on_init, on_attach).
                    type = types.nullOr types.attrs;
                    default = null;
                    description = "vim.lsp.Config table. null => enable only, no config file generated.";
                };
            };
        };

        pluginModule = {name, ...}: {
            options = {
                src = mkOption {
                    type = types.str;
                    description = "Source passed verbatim to vim.pack.add (e.g. \"gh:owner/repo\").";
                };
                name = mkOption {
                    type = types.str;
                    default = name;
                    description = "Module name used in require(name).setup(). Defaults to the attribute key.";
                };
                config = mkOption {
                    # Loose type: the value is handed straight to the Lua
                    # serializer, which understands attrsets, lists, scalars
                    # and mkRaw leaves. null => no setup() call at all;
                    # {} => setup({}); otherwise setup({...}).
                    type = types.nullOr (types.oneOf [types.attrs (types.listOf types.anything)]);
                    default = null;
                    description = "Table passed to require(name).setup(). null omits the setup call entirely.";
                };
                keymaps = mkOption {
                    type = types.listOf (types.submodule keymapModule);
                    default = [];
                    description = "Keymaps emitted (as vim.keymap.set) after this plugin's setup.";
                };
                autocmds = mkOption {
                    type = types.listOf (types.submodule autocmdModule);
                    default = [];
                    description = "Autocommands emitted (as vim.api.nvim_create_autocmd) after this plugin's setup.";
                };
                extraLua = mkOption {
                    type = types.nullOr types.lines;
                    default = null;
                    description = "Verbatim Lua appended after this plugin's block (keymaps, colorscheme, etc.).";
                };
                packadd = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Load via vim.cmd.packadd(name) instead of the batched vim.pack.add.";
                };
                lazy = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Register with vim.pack.add but do not load until :packadd (uses load = function() end).";
                };
                priority = mkOption {
                    type = types.int;
                    default = 50;
                    description = "Lower emits earlier. Ties broken by attribute key.";
                };
            };
        };

        # Ordered list of enabled plugins: by priority, then key.
        pluginList = let
            named = lib.mapAttrsToList (key: p: p // {_key = key;}) cfg.plugins;
        in
            lib.sort (a: b:
                if a.priority != b.priority
                then a.priority < b.priority
                else a._key < b._key)
            named;

        # Plugins that go into the single batched vim.pack.add call (eager,
        # non-packadd). Lazy plugins are added separately with a no-op loader.
        eager = builtins.filter (p: !p.packadd && !p.lazy) pluginList;
        lazyPlugins = builtins.filter (p: !p.packadd && p.lazy) pluginList;
        packaddPlugins = builtins.filter (p: p.packadd) pluginList;

        addBlock =
            lib.optionalString (eager != [])
            ("vim.pack.add(" + toLua (map (p: p.src) eager) + ")\n\n");

        lazyBlock =
            lib.optionalString (lazyPlugins != [])
            (lib.concatMapStringsSep "\n" (p:
                "vim.pack.add(" + toLua [p.src] + ", { load = function() end })")
            lazyPlugins
            + "\n\n");

        packaddBlock =
            lib.optionalString (packaddPlugins != [])
            (lib.concatMapStringsSep "\n" (p: "vim.cmd.packadd(${toLua p.name})") packaddPlugins
                + "\n\n");

        setupBlockFor = p: let
            setupLine =
                if p.config == null
                then ""
                else "require(${toLua p.name}).setup(${toLua p.config})\n";
            keymapsLua =
                lib.optionalString (p.keymaps != [])
                (lib.concatMapStringsSep "\n" keymapExpr p.keymaps + "\n");
            autocmdsLua =
                lib.optionalString (p.autocmds != [])
                (lib.concatMapStringsSep "\n" autocmdExpr p.autocmds + "\n");
            extra =
                if p.extraLua == null
                then ""
                else p.extraLua + "\n";
            body = setupLine + keymapsLua + autocmdsLua + extra;
        in
            lib.optionalString (body != "") ("-- ${p._key}\n" + body);

        setupBlocks = lib.concatStringsSep "\n" (builtins.filter (s: s != "") (map setupBlockFor pluginList));

        globalsBlock = lib.optionalString (cfg.globals != {}) (
            lib.concatStringsSep "\n"
            (lib.mapAttrsToList (k: v: "vim.g[${toLua k}] = ${toLua v}") cfg.globals)
            + "\n\n"
        );

        optionsBlock = lib.optionalString (cfg.options != {}) (
            lib.concatStringsSep "\n"
            (lib.mapAttrsToList (k: v: "vim.opt[${toLua k}] = ${toLua v}") cfg.options)
            + "\n\n"
        );

        keymapsBlock = lib.optionalString (cfg.keymaps != []) (
            lib.concatMapStringsSep "\n" keymapExpr cfg.keymaps + "\n\n"
        );

        autocmdsBlock = lib.optionalString (cfg.autocmds != []) (
            lib.concatMapStringsSep "\n" autocmdExpr cfg.autocmds + "\n\n"
        );

        preamble = ''
            vim.g.mapleader = ${toLua cfg.leader}
            vim.g.maplocalleader = ${toLua cfg.localleader}
            vim.loader.enable()
        '';

        initLua =
            preamble
            + "\n"
            + globalsBlock
            + optionsBlock
            + lib.optionalString (cfg.extraConfigPre != "") (cfg.extraConfigPre + "\n\n")
            + addBlock
            + lazyBlock
            + packaddBlock
            + setupBlocks
            + (lib.optionalString (setupBlocks != "") "\n")
            + keymapsBlock
            + autocmdsBlock
            + lspEnableBlock
            + lib.optionalString (cfg.extraConfigPost != "") (cfg.extraConfigPost + "\n");

        # Assemble once, then luacheck the whole file. `vim` is allowed as a
        # global; only real errors (luacheck exit >= 2) fail the build, style
        # warnings (exit 1) are tolerated. The validated file is what hjem links.
        initLuaFile = pkgs.runCommand "nvim-module-init.lua" {
            inherit initLua;
            passAsFile = ["initLua"];
            nativeBuildInputs = [pkgs.luaPackages.luacheck];
        } ''
            luacheck --globals vim --no-max-line-length --no-max-comment-line-length "$initLuaPath" || {
                status=$?
                if [ "$status" -ge 2 ]; then
                    echo "luacheck reported errors in generated init.lua" >&2
                    exit 1
                fi
            }
            cp "$initLuaPath" "$out"
        '';

        # Validate a standalone .lua module file at build time, returning the
        # same file (store path) so hjem can link it. Self-contained Lua modules
        # (pickers, query runners) that aren't config-shaped live here.
        checkLuaFile = name: src:
            pkgs.runCommand "nvim-module-${name}" {
                nativeBuildInputs = [pkgs.luaPackages.luacheck];
            } ''
                luacheck --globals vim --no-max-line-length --no-max-comment-line-length ${src} || {
                    status=$?
                    if [ "$status" -ge 2 ]; then
                        echo "luacheck reported errors in ${name}" >&2
                        exit 1
                    fi
                }
                cp ${src} "$out"
            '';

        # extraFiles: map "plugin/foo.lua" -> validated source. Placed verbatim
        # under ~/.config/nvim-module/<target>.
        extraFileEntries =
            lib.mapAttrs' (
                target: src:
                    lib.nameValuePair ".config/nvim-module/${target}" {
                        # Only Lua files are luacheck-validated; .vim et al. are
                        # copied through unchanged.
                        source =
                            if lib.hasSuffix ".lua" target
                            then checkLuaFile (lib.strings.sanitizeDerivationName target) src
                            else src;
                    }
            )
            cfg.extraFiles;

        # Validate a generated Lua string and return its store path.
        checkLuaText = name: text:
            pkgs.runCommand "nvim-module-${name}" {
                inherit text;
                passAsFile = ["text"];
                nativeBuildInputs = [pkgs.luaPackages.luacheck];
            } ''
                luacheck --globals vim --no-max-line-length --no-max-comment-line-length "$textPath" || {
                    status=$?
                    if [ "$status" -ge 2 ]; then
                        echo "luacheck reported errors in ${name}" >&2
                        exit 1
                    fi
                }
                cp "$textPath" "$out"
            '';

        # ftplugins: attrset keyed by filetype -> after/ftplugin/<ft>.lua
        ftpluginText = ft: spec: let
            settingsLua =
                lib.concatStringsSep "\n"
                (lib.mapAttrsToList (k: v: "vim.opt_local[${toLua k}] = ${toLua v}") spec.settings);
            extra = lib.optionalString (spec.extraLua != null) ("\n" + spec.extraLua);
        in
            settingsLua + extra + "\n";

        ftpluginEntries =
            lib.mapAttrs' (
                ft: spec:
                    lib.nameValuePair ".config/nvim-module/after/ftplugin/${ft}.lua" {
                        source = checkLuaText "ftplugin-${lib.strings.sanitizeDerivationName ft}" (ftpluginText ft spec);
                    }
            )
            cfg.ftplugins;

        # lsp: attrset keyed by server -> after/lsp/<name>.lua (returns Config).
        # Enable list is emitted into init.lua (lspEnableBlock).
        lspConfigEntries =
            lib.mapAttrs' (
                server: spec:
                    lib.nameValuePair ".config/nvim-module/after/lsp/${server}.lua" {
                        source = checkLuaText "lsp-${lib.strings.sanitizeDerivationName server}" ("return ${toLua spec.settings}\n");
                    }
            )
            (lib.filterAttrs (_: spec: spec.settings != null) cfg.lsp);

        lspEnabled = lib.attrNames (lib.filterAttrs (_: spec: spec.enable) cfg.lsp);
        lspEnableBlock =
            lib.optionalString (lspEnabled != [])
            ("vim.lsp.enable(" + toLua lspEnabled + ")\n\n");
    in {
        options.programs.nvim-module = {
            enable = mkEnableOption "the declarative Nix-driven Neovim sibling config (nvim-module)";

            leader = mkOption {
                type = types.str;
                default = " ";
                description = "vim.g.mapleader";
            };
            localleader = mkOption {
                type = types.str;
                default = "\\";
                description = "vim.g.maplocalleader";
            };
            extraConfigPre = mkOption {
                type = types.lines;
                default = "";
                description = "Verbatim Lua emitted after the preamble, before plugins load.";
            };
            extraConfigPost = mkOption {
                type = types.lines;
                default = "";
                description = "Verbatim Lua emitted at the very end of init.lua.";
            };
            globals = mkOption {
                type = types.attrsOf types.anything;
                default = {};
                description = "vim.g globals. Each key => vim.g[key] = value (mkRaw allowed).";
            };
            options = mkOption {
                type = types.attrsOf types.anything;
                default = {};
                description = "vim.opt options. Each key => vim.opt[key] = value (mkRaw allowed).";
            };
            keymaps = mkOption {
                type = types.listOf (types.submodule keymapModule);
                default = [];
                description = "Global keymaps emitted as vim.keymap.set calls.";
            };
            autocmds = mkOption {
                type = types.listOf (types.submodule autocmdModule);
                default = [];
                description = "Autocommands emitted as vim.api.nvim_create_autocmd calls.";
            };
            plugins = mkOption {
                type = types.attrsOf (types.submodule pluginModule);
                default = {};
                description = "Plugins keyed by an identifier. Order controlled by priority then key.";
            };
            extraFiles = mkOption {
                type = types.attrsOf types.path;
                default = {};
                example = lib.literalExpression ''{ "plugin/artisan.lua" = ./lua/artisan.lua; }'';
                description = ''
                    Self-contained Lua module files placed under
                    ~/.config/nvim-module/<target>. Each is luacheck-validated at
                    build time. Use for real Lua modules (pickers, runners) that
                    are logic rather than config; files under plugin/ are
                    auto-sourced by neovim at startup.
                '';
            };
            ftplugins = mkOption {
                type = types.attrsOf (types.submodule ftpluginModule);
                default = {};
                description = "Filetype settings emitted as after/ftplugin/<ft>.lua (vim.opt_local).";
            };
            lsp = mkOption {
                type = types.attrsOf (types.submodule lspServerModule);
                default = {};
                description = "LSP servers: enable + optional vim.lsp.Config (after/lsp/<name>.lua).";
            };
        };

        config = mkIf cfg.enable {
            packages = [
                launcher
                neovim
                pkgs.tree-sitter
                pkgs.gcc
            ];
            files =
                {
                    ".config/nvim-module/init.lua".source = initLuaFile;
                }
                // extraFileEntries
                // ftpluginEntries
                // lspConfigEntries;
        };
    };
}
