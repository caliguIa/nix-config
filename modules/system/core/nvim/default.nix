# System-wide nvim, built from the `nvim` option so other buckets (dev) can
# swap the package and add plugins/tools. Lua config: ./lua (hjem.core).
{ ... }:
{
    flake.modules.nixos.core =
        {
            config,
            lib,
            pkgs,
            ...
        }:
        let
            inherit (lib) mkOption types;
            cfg = config.nvim;

            neovim = pkgs.wrapNeovimUnstable cfg.package {
                viAlias = true;
                vimAlias = true;
                withNodeJs = false;
                withPython3 = false;
                withRuby = false;
                wrapRc = false;
                inherit (cfg) waylandSupport;
                plugins =
                    cfg.plugins
                    ++ map (plugin: {
                        inherit plugin;
                        optional = true;
                    }) cfg.optionalPlugins;
                wrapperArgs = [
                    "--suffix"
                    "PATH"
                    ":"
                    (lib.makeBinPath cfg.tools)
                ];
            };

            vimdiff = pkgs.writeShellScriptBin "vimdiff" ''
                exec ${lib.getExe neovim} -d "$@"
            '';
        in
        {
            options.nvim = {
                package = mkOption {
                    type = types.package;
                    default = pkgs.neovim-unwrapped;
                    description = "Unwrapped neovim to wrap.";
                };
                plugins = mkOption {
                    type = types.listOf types.package;
                    default = [ ];
                    description = "Plugins loaded at startup.";
                };
                optionalPlugins = mkOption {
                    type = types.listOf types.package;
                    default = [ ];
                    description = "Plugins installed under pack/*/opt, loaded with :packadd.";
                };
                tools = mkOption {
                    type = types.listOf types.package;
                    default = [ ];
                    description = "Packages appended to nvim's PATH only (LSP servers, formatters).";
                };
                waylandSupport = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Put wl-clipboard on nvim's PATH. Off for headless hosts: it drags in xdg-utils and perl.";
                };
                finalPackage = mkOption {
                    type = types.package;
                    readOnly = true;
                    default = neovim;
                    description = "The wrapped nvim.";
                };
            };

            config = {
                nvim.plugins = [ pkgs.vimPlugins.oil-nvim ];
                environment.systemPackages = [
                    neovim
                    vimdiff
                ];
            };
        };

    flake.modules.hjem.core =
        { lib, ... }:
        {
            files = import ./_link.nix { inherit lib; } ./lua;
        };
}
