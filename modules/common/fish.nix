{pkgs, ...}: {
    programs.fish = {
        enable = true;
        generateCompletions = true;
        plugins = [
            {
                name = "foreign-env";
                inherit (pkgs.fishPlugins.foreign-env) src;
            }
            {
                name = "auto-pairs";
                inherit (pkgs.fishPlugins.autopair) src;
            }
        ];
        shellAliases = {
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
            nix-rebuild = "cd $HOME/nix-config; just build; cd -";
            nix-gc = "nix-store --gc; nix-collect-garbage -d; sudo nix-collect-garbage --delete-old; nix-env --delete-generations old; sudo nix-store -gc; sudo nix-collect-garbage -d; nix store gc; sudo nix store gc";
            t = "tmux attach-session";
            update = "softwareupdate -ia";
            updatel = "softwareupdate -l";
            ":q" = "exit";
            vpn-up = "aws ec2 start-instances --instance-ids i-0233140dd34c2958c --region eu-west-2";
            vpn-down = "aws ec2 stop-instances --instance-ids i-0233140dd34c2958c --region eu-west-2";
        };
        functions = {
            artisan = ''
                set -l artisan_path (_artisan_find)

                if test -z "$artisan_path"
                    echo "fish-artisan: artisan not found. Are you in a Laravel directory?" >&2
                    return 1
                end

                set -l laravel_path (dirname $artisan_path)
                set -l docker_compose_config_path (find $laravel_path -maxdepth 1 \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \) | head -n1)
                set -l artisan_cmd

                if test -z "$docker_compose_config_path"
                    set artisan_cmd "php $artisan_path"
                else
                    if test (grep "laravel/sail" $docker_compose_config_path | head -n1) != ""
                        set artisan_cmd "$laravel_path/vendor/bin/sail artisan"
                    else
                        set -l docker_compose_cmd (_docker_compose_cmd)
                        set -l docker_compose_service_name "platform"
                        if isatty stdout
                            set artisan_cmd "$docker_compose_cmd exec $docker_compose_service_name php artisan"
                        else
                            set artisan_cmd "$docker_compose_cmd exec -T $docker_compose_service_name php artisan"
                        end
                    end
                end

                set -l artisan_start_time (date +%s)

                eval $artisan_cmd $argv

                set -l artisan_exit_status $status

                if string match -q "make:*" $argv[1]; and test -n "$ARTISAN_OPEN_ON_MAKE_EDITOR"
                    find \
                        "$laravel_path/app" \
                        "$laravel_path/tests" \
                        "$laravel_path/database" \
                        -type f \
                        -newermt "-"(math (date +%s) - $artisan_start_time + 1)" seconds" \
                        -exec $ARTISAN_OPEN_ON_MAKE_EDITOR {} \; 2>/dev/null
                end

                return $artisan_exit_status
            '';
            _artisan_find = ''
                # Look for artisan up the file tree
                set -l dir .
                while test (realpath $dir) != "/"
                    if test -f "$dir/artisan"
                        echo "$dir/artisan"
                        return 0
                    end
                    set dir "$dir/.."
                end
                return 1
            '';
            _artisan_add_completion = ''
                if test -n (_artisan_find)
                    for cmd in (_artisan_get_command_list)
                        echo $cmd
                    end
                end
            '';
            _artisan_get_command_list = ''
                artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"
            '';
            _docker_compose_cmd = ''
                if docker compose &>/dev/null
                    echo "docker compose"
                else
                    echo "docker-compose"
                end
            '';
            envsource = ''
                for line in (cat $argv | grep -v '^#')
                  set item (string split -m 1 '=' $line)
                  set -gx $item[1] $item[2]
                  echo "Exported key $item[1]"
                end
            '';
        };
        shellInit = ''
            if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]
                fenv source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
                fenv source "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"
            end
            set -U fish_greeting

            if [ -e "~/.local/auth/fish_env.fish" ]
                source ~/.local/auth/fish_env.fish
            end
        '';
    };
}
