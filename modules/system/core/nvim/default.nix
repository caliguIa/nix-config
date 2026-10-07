{ inputs, ... }: {
    flake.modules.hjem.core =
        {
            pkgs,
            lib,
            ...
        }:
        let
            inherit (lib.meta) getExe;
            inherit (lib.strings) makeBinPath;

            inherit (import ../_editor-tools.nix { inherit pkgs; }) tools mago;

            neovim = pkgs.wrapNeovimUnstable inputs.nvim-nightly.packages.${pkgs.stdenvNoCC.system}.neovim {
                withNodeJs = false;
                withPython3 = false;
                withRuby = false;
                wrapRc = false;
                wrapperArgs = [
                    "--suffix"
                    "PATH"
                    ":"
                    (makeBinPath tools)
                    # Absolute path to nixpkgs' tsc (7.x, the Go port with `--lsp`),
                    # so a project's node_modules tsc (5.x) on PATH can't shadow it.
                    "--set"
                    "NVIM_TSC"
                    "${pkgs.typescript}/bin/tsc"
                ];
            };

            aliases = pkgs.runCommand "nvim-aliases" { } ''
                mkdir -p $out/bin
                ln -s ${getExe neovim} $out/bin/vi
                ln -s ${getExe neovim} $out/bin/vim
                cat > $out/bin/vimdiff <<EOF
                #!${pkgs.runtimeShell}
                exec ${getExe neovim} -d "\$@"
                EOF
                chmod +x $out/bin/vimdiff
            '';
        in
        {
            packages = [
                neovim
                aliases
                mago
                pkgs.tree-sitter
                pkgs.gcc
            ];
            files = {
                ".config/nvim/init.lua".source = ./lua/init.lua;
                ".config/nvim/after".source = ./lua/after;
                ".config/nvim/plugin".source = ./lua/plugin;
            };
        };
}
