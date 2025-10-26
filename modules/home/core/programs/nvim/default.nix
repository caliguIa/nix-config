{inputs, ...}: {
    flake.modules.homeManager.core = {
        pkgs,
        lib,
        ...
    }: {
        config = let
            packageName = "nvim";
            plugins = with pkgs.vimPlugins; [
                kanso-nvim
                plenary-nvim
                oil-nvim
                mini-nvim
                nvim-lspconfig
                conform-nvim
                git-conflict-nvim
                vim-test
                vim-tmux-navigator
                nvim-bqf
                neogit
                fff-nvim
                codecompanion-nvim
                nvim-treesitter
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                ts-comments-nvim
                nvim-ts-autotag
                aerial-nvim
            ];
            customPlugins = with pkgs; [
                (vimUtils.buildVimPlugin {
                    name = "indentmini.nvim";
                    src = fetchFromGitHub {
                        owner = "nvimdev";
                        repo = "indentmini.nvim";
                        rev = "main";
                        hash = "sha256-YDO48kLOkzbJ9HDiQ0rQ/bbvyD8FQ9iNfSl1V0naUAs=";
                    };
                })
                (vimUtils.buildVimPlugin {
                    name = "zendiagram.nvim";
                    src = fetchFromGitHub {
                        owner = "caliguIa";
                        repo = "zendiagram.nvim";
                        rev = "main";
                        hash = "sha256-vJMoeMUAKliPy9MF6oUd+gSQ1cNXPCEcju8OXEMvYew=";
                    };
                })
                # (vimUtils.buildVimPlugin {
                #     name = "timber.nvim";
                #     src = fetchFromGitHub {
                #         owner = "Goose97";
                #         repo = "timber.nvim";
                #         rev = "main";
                #         hash = "";
                #     };
                # })
            ];
            runtimeDeps = with pkgs; [
                emmylua-ls
                marksman
                nixd
                taplo
                just-lsp
                vscode-langservers-extracted
                nodePackages.bash-language-server
                alejandra
                lua-language-server
                sleek
                stylua
                sqruff
            ];
            foldPlugins = builtins.foldl' (
                acc: next:
                    acc
                    ++ [next]
                    ++ (foldPlugins (next.dependencies or []))
            ) [];
            pluginsWithDeps = lib.unique (foldPlugins plugins);
            allPlugins = pluginsWithDeps ++ customPlugins;
            configPlugin = pkgs.runCommandLocal "nvim-config" {} ''
                mkdir -p $out
                cp -r ${./.}/* $out/
            '';
            packpath = pkgs.runCommandLocal "packpath" {} ''
                mkdir -p $out/pack/${packageName}/start
                ln -vsfT ${configPlugin} $out/pack/${packageName}/start/nvim-config
                ${lib.concatMapStringsSep "\n"
                (plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}")
                allPlugins}
            '';
            nvim = pkgs.symlinkJoin {
                name = "nvim";
                paths = [inputs.nvim-nightly.packages.${pkgs.system}.neovim];
                nativeBuildInputs = [pkgs.makeWrapper];
                postBuild = ''
                    wrapProgram $out/bin/nvim \
                      --add-flags '-u' \
                      --add-flags 'NORC' \
                      --add-flags '--cmd' \
                      --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
                      --set-default NVIM_APPNAME nvim \
                      --set NVIM_PACKPATH ${packpath} \
                      --prefix PATH : ${lib.makeBinPath runtimeDeps}
                    ln -sf $out/bin/nvim $out/bin/vi
                    ln -sf $out/bin/nvim $out/bin/vim
                    ln -sf $out/bin/nvim $out/bin/bim
                '';
                passthru = {
                    inherit packpath configPlugin;
                    plugins.start = allPlugins;
                    tools = runtimeDeps;
                };
            };
        in {
            home.packages = [nvim];
        };
    };
}
