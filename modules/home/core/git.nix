{
    flake.modules.homeManager.core = {
        programs.git = {
            enable = true;
            settings = {
                user = {
                    name = "Cal";
                    email = "acc@calrichards.io";
                };
                alias = {
                    a = "add";
                    aa = "add .";
                    b = "branch";
                    c = "commit";
                    co = "checkout";
                    p = "push";
                    u = "pull";
                    f = "fetch --all";
                    undocommit = "reset --soft HEAD^";
                    commits = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
                    cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop\\|main' | xargs -n 1 -r git branch -d";
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
                    context = 3;
                    renames = "copies";
                    interHunkContext = 10;
                };
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
            ignores = [
                "env-vars.private.zsh"
                "*.pyc"
                ".DS_Store"
                "Desktop.ini"
                "._*"
                "Thumbs.db"
                ".Spotlight-V100"
                ".Trashes"
                ".vscode"
                "luac.out"
                "*.src.rock"
                "*.zip"
                "*.tar.gz"
                "*.o"
                "*.os"
                "*.ko"
                "*.obj"
                "*.elf"
                "*.gch"
                "*.pch"
                "*.lib"
                "*.a"
                "*.la"
                "*.lo"
                "*.def"
                "*.exp"
                "*.dll"
                "*.so"
                "*.so.*"
                "*.dylib"
                "*.exe"
                "*.out"
                "*.app"
                "*.i*86"
                "*.x86_64"
                "*.hex"
            ];
        };
        home.shellAliases = {
            ga = "git add";
            gaa = "git add .";
            gap = "git add --patch";
            gb = "git branch";
            gc = "git commit";
            gd = "git diff";
            gi = "git init";
            gs = "git status";
            gco = "git checkout";
            gp = "git push";
            gu = "git pull";
            gfp = "git fetch && git pull";
            gcl = "git clone";
            undocommit = "git reset --soft HEAD^";
        };
        programs.delta = {
            enable = true;
            enableGitIntegration = true;
            options = {
                navigate = true;
                navigate-regex = "^(commit|added:|removed:|renamed:|modified:|•)";
                true-color = "always";
                markEmptyLines = false;
                hyperlinks = true;
                file-added-label = "added:";
                file-modified-label = "modified:";
                file-removed-label = "removed:";
                file-renamed-label = "renamed:";
                right-arrow = "⟶  ";
                hyperlinks-file-link-format = "file://{path}";
                inspect-raw-lines = true;
                keep-plus-minus-markers = false;
                blame-palette = "#000000 #222222 #444444";
                line-numbers = false;
                max-line-distance = "0.6";
                max-line-length = 3000;
                diff-stat-align-width = 48;
                line-fill-method = "ansi";
                paging = "auto";
                side-by-side = false;
                syntax-theme = "catppuccin";
                word-diff-regex = "\w+";
                commit-decoration-style = "none";
                file-style = "magenta";
                file-decoration-style = "ul ol normal";
                hunk-header-decoration-style = "none";
                zero-style = "normal";
                plus-style = "black #D9FDD4";
                plus-non-emph-style = "black #D9FDD4";
                plus-emph-style = "black #B1EBA8";
                plus-empty-line-marker-style = "black #B1EBA8";
                minus-style = "black #F9E1DF";
                minus-non-emph-style = "black #F9E1DF";
                minus-emph-style = "black #F5C3C1";
                minus-empty-line-marker-style = "black #F5C3C1";
            };
        };
    };
}
