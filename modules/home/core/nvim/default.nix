topLevel @ {
    inputs,
    lib,
    ...
}: {
    options.flake.meta.nvimExtraPackages = lib.mkOption {
        type = lib.types.functionTo (lib.types.listOf lib.types.package);
        default = _: [];
        description = ''
            Function taking pkgs and returning packages to place on Neovim's
            wrapper PATH (LSPs, formatters, etc). Definitions from all modules
            are merged (list results are concatenated).
        '';
    };

    config.flake.modules.hjem.core = {pkgs, ...}: let
        neovimUnwrapped = inputs.nvim-nightly.packages.${pkgs.stdenvNoCC.system}.neovim;

        config = pkgs.neovimUtils.makeNeovimConfig {
            withNodeJs = true;
            withPython3 = false;
            withRuby = false;
            extraLuaPackages = _: [];
            plugins = [];
        };

        neovim = pkgs.wrapNeovimUnstable neovimUnwrapped (config
            // {
                wrapperArgs =
                    (lib.escapeShellArgs config.wrapperArgs)
                    + " "
                    + ''--suffix PATH : "${lib.makeBinPath (topLevel.config.flake.meta.nvimExtraPackages pkgs)}"'';
                wrapRc = false;
            });

        aliases = pkgs.runCommand "nvim-aliases" {} ''
            mkdir -p $out/bin
            ln -s ${neovim}/bin/nvim $out/bin/vi
            ln -s ${neovim}/bin/nvim $out/bin/vim
            cat > $out/bin/vimdiff <<EOF
            #!${pkgs.runtimeShell}
            exec ${neovim}/bin/nvim -d "\$@"
            EOF
            chmod +x $out/bin/vimdiff
        '';
    in {
        packages = [
            neovim
            aliases
        ];
    };
}
