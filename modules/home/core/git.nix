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
    };
}
