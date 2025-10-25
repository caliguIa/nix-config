{
    flake.modules.homeManager.core = {
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
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
            "....." = "cd ../../../..";
            ":q" = "exit";
            dl = "cd ~/Downloads";
            dt = "cd ~/Desktop";
            df = "cd ~/nix-config";
            cf = "cd ~/.config";
            ous = "cd ~/ous/platform";
            dev = "cd ~/dev";
            nvp = "cd ~/dev/nvim-plugins";
            ls = "eza --color=always --long -a --git --icons=always";
            cat = "bat";
            dc = "docker-compose";
            dcu = "docker-compose up";
            dcb = "docker-compose build";
            dps = "docker ps";
            ip = "curl ifconfig.io";
            localip = "ipconfig getifaddr en0";
            update = "softwareupdate -ia";
            updatel = "softwareupdate -l";
        };
    };
}
