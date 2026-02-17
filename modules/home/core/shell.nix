{
    flake.modules.homeManager.core = {
        stylix.targets.fish.enable = true;
        programs.fish = {
            enable = true;
            generateCompletions = true;
            interactiveShellInit = ''
                set -U fish_greeting
                test -f ~/.local/auth/fish_env.fish; and source ~/.local/auth/fish_env.fish
                bind --mode default \ce kitty_scrollback_edit_command_buffer
                bind --mode visual \ce kitty_scrollback_edit_command_buffer
                bind --mode insert \ce kitty_scrollback_edit_command_buffer
            '';
            functions = {
                fish_greeting = "";
                kitty_scrollback_edit_command_buffer = ''
                    set --local --export VISUAL '/nix/store/zdairpnlmqa27hwa4wkqmxsw05a18kdf-vim-pack-dir/pack/myNeovimPackages/start/kitty-scrollback.nvim/scripts/edit_command_line.sh'
                    edit_command_buffer
                    commandline ""
                '';
            };
        };
        home.shellAliases = {
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
            "....." = "cd ../../../..";
            ":q" = "exit";
            dl = "cd ~/Downloads";
            dt = "cd ~/Desktop";
            cf = "cd ~/.config";
            ous = "cd ~/ous/platform";
            dev = "cd ~/dev";
            ls = "eza --color=always --long -a --git --icons=always";
            cat = "bat";
            dps = "docker ps";
        };
    };
}
