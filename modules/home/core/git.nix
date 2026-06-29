{
    flake.modules.homeManager.core = {pkgs, ...}: {
        programs.gh-dash.enable = true;
        programs.gh.enable = true;
        programs.gh.extensions = with pkgs; [gh-dash];
        programs.git = {
            enable = true;
            signing.format = null;
            settings = {
                alias = {
                    dlog = "-c diff.external=difft log --ext-diff";
                    dshow = "-c diff.external=difft show --ext-diff";
                    ddiff = "-c diff.external=difft diff";
                    dl = "-c diff.external=difft log -p --ext-diff";
                    ds = "-c diff.external=difft show --ext-diff";
                    dft = "-c diff.external=difft diff";
                };
                user = {
                    name = "Cal";
                    email = "acc@calrichards.io";
                };
                advice = {
                    addEmptyPathspec = false;
                    pushNonFastForward = false;
                    statusHints = false;
                };
                core = {
                    editor = "nvim";
                    compression = 9;
                    whitespace = "error";
                    preloadindex = true;
                    symlinks = true;
                    autocrlf = "input";
                };
                diff = {
                    external = "difft";
                    tool = "difftastic";
                    context = 3;
                    renames = "copies";
                    interHunkContext = 10;
                };
                difftool = {
                    prompt = false;
                    "difftastic" = {
                        cmd = "difft '$MERGED' '$LOCAL' 'abcdef1' '100644' '$REMOTE' 'abcdef2' '100644'";
                    };
                };
                pager.difftool = true;
                fetch.prune = true;
                gc.auto = 200;
                init.defaultBranch = "main";
                push = {
                    autoSetupRemote = true;
                    default = "current";
                };
                remote = {
                    pushDefault = "origin";
                };
                pull = {
                    default = "current";
                };
                interactive.singlekey = true;
                status = {
                    branch = true;
                    showStash = true;
                    showUntrackedFiles = "all";
                };
                url = {
                    "git@github.com:" = {
                        insteadOf = [
                            "https://github.com/"
                            "gh:"
                        ];
                    };
                    "git@github.com:caliguIa/" = {
                        insteadOf = [
                            "https://github.com/caliguIa/"
                            "cal:"
                        ];
                    };
                };
            };
        };
        programs.lazygit = {
            enable = true;
            enableBashIntegration = true;
            settings = {
                git = {
                    pagers = [
                        {useExternalDiffGitConfig = true;}
                    ];
                };
                gui = {
                    border = "single";
                    nerdFontsVersion = "3";
                    theme = {
                        selectedLineBgColor = ["default"];
                    };
                };
                os = {
                    edit = "[ -z \"$NVIM\" ] && (nvim -- {{filename}}) || (nvim --server $NVIM --remote-send '<cmd>close<cr><cmd>lua EditFromLazygit({{filename}})<CR>')";
                    editAtLine = "[ -z \"$NVIM\" ] && (nvim +{{line}} -- {{filename}}) || nvim --server $NVIM --remote-send '<cmd>close<CR><cmd>lua EditLineFromLazygit({{filename}},{{line}})<CR>'";
                };
                keybinding.universal = {
                    quitWithoutChangingDirectory = ["q" "<ctrl+c>"];
                    quit = ["Q"];
                };
            };
        };
    };
}
