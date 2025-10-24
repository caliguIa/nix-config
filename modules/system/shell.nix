let
    username = "caligula";
in {
    flake.modules.darwin.shell = {pkgs, ...}: let
        homeDirectory = "/Users/${username}";
    in {
        programs.fish.enable = true;
        users.users.${username}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            systemPath = [
                "/Applications/Docker.app/Contents/Resources/bin"
                "${homeDirectory}/.cargo/bin"
                "${homeDirectory}/.local/bin"
                "${homeDirectory}/go/bin"
            ];
            variables = {
                EDITOR = "nvim";
                XDEBUG_MODE = "off";
                RAINFROG_CONFIG = "${homeDirectory}/.config/rainfrog";
            };
        };
    };

    flake.modules.nixos.shell = {pkgs, ...}: {
        programs.fish.enable = true;
        users.users.${username}.shell = pkgs.fish;
        environment = {
            shells = [pkgs.fish];
            variables = {
                EDITOR = "nvim";
            };
        };
    };

    flake.modules.homeManager.shell = {
        programs.fish = {
            enable = true;
            generateCompletions = true;
            interactiveShellInit = ''
                set -U fish_greeting
                test -f ~/.local/auth/fish_env.fish; and source ~/.local/auth/fish_env.fish
            '';
        };
        home.file = {".hushlogin".text = "";};
        home.shellAliases = {
            dl = "cd ~/Downloads";
            dt = "cd ~/Desktop";
            df = "cd ~/nix-config";
            cf = "cd ~/.config";
            ous = "cd ~/ous/platform";
            dev = "cd ~/dev";
            nvp = "cd ~/dev/nvim-plugins";
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
            "....." = "cd ../../../..";
            ls = "eza --color=always --long -a --git --icons=always";
            cat = "bat";
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
            dc = "docker-compose";
            dcu = "docker-compose up";
            dcb = "docker-compose build";
            dps = "docker ps";
            ip = "curl ifconfig.io";
            localip = "ipconfig getifaddr en0";
            t = "tmux attach-session";
            update = "softwareupdate -ia";
            updatel = "softwareupdate -l";
            ":q" = "exit";
        };
    };
}
