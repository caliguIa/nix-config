{ config, lib, ... }:
{
  enable = true;
  autocd = false;
  autosuggestion.enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = false;
  defaultKeymap = "emacs";
  history.path = "${config.xdg.dataHome}/zsh/zsh_history";
  dotDir = ".config/zsh";
  shellAliases = {
    "~" = "cd ~";
    dl = "cd ~/Downloads";
    dt = "cd ~/Desktop";
    df = "cd ~/nix-config";
    cf = "cd ~/.config";
    cfg = "cd ~/nix-config/modules/shared/config";
    nx = "cd ~/nix-config/";
    ous = "cd ~/ous/platform";
    dev = "cd ~/dev";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ls = "eza --color=always --long -a --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    cat = "bat";
    ga = "git add";
    gap = "git add --patch";
    gb = "git branch";
    gc = "git commit";
    gd = "git diff";
    gi = "git init";
    gst = "git status";
    gco = "git checkout";
    gs = "git switch";
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
    kanata-reload = "sudo launchctl unload /Library/LaunchDaemons/com.jtroo.kanata.plist; sudo launchctl load  /Library/LaunchDaemons/com.jtroo.kanata.plist";
    nix-rebuild = "cd $HOME/nix-config; just build; cd -";
    nix-gc = "nix-store --gc; nix-collect-garbage -d; sudo nix-collect-garbage --delete-old; nix-env --delete-generations old; sudo nix-store -gc; sudo nix-collect-garbage -d; nix store gc; sudo nix store gc";
    t = "tmux attach-session";
    update = "softwareupdate -ia";
    updatel = "softwareupdate -l";
    ":q" = "exit";
    vpn-up = "aws ec2 start-instances --instance-ids i-0233140dd34c2958c --region eu-west-2";
    vpn-down = "aws ec2 stop-instances --instance-ids i-0233140dd34c2958c --region eu-west-2";
  };
  initContent = lib.mkBefore ''
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    fi

    [[ ! -r /Users/caligula/.opam/opam-init/init.zsh ]] || source /Users/caligula/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

    source ~/.local/auth/.env

    function artisan() {
        local artisan_path=`_artisan_find`

        if [ "$artisan_path" = "" ]; then
            >&2 echo "zsh-artisan: artisan not found. Are you in a Laravel directory?"
            return 1
        fi

        local laravel_path=`dirname $artisan_path`
        local docker_compose_config_path=`find $laravel_path -maxdepth 1 \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \) | head -n1`
        local artisan_cmd

        if [ "$docker_compose_config_path" = "" ]; then
            artisan_cmd="php $artisan_path"
        else
            if [ "`grep "laravel/sail" $docker_compose_config_path | head -n1`" != "" ]; then
                artisan_cmd="$laravel_path/vendor/bin/sail artisan"
            else
                local docker_compose_cmd=`_docker_compose_cmd`
                # local docker_compose_service_name=`$docker_compose_cmd ps --services 2>/dev/null | grep 'platform\|app\|php\|api\|workspace\|laravel\.test\|webhost' | head -n1`
                local docker_compose_service_name="platform"
                if [ -t 1 ]; then
                    artisan_cmd="$docker_compose_cmd exec $docker_compose_service_name php artisan"
                else
                    # The command is not being run in a TTY (e.g. it's being called by the completion handler below)
                    artisan_cmd="$docker_compose_cmd exec -T $docker_compose_service_name php artisan"
                fi
            fi
        fi

        local artisan_start_time=`date +%s`

        eval $artisan_cmd $*

        local artisan_exit_status=$? # Store the exit status so we can return it later

        if [[ $1 = "make:"* && $ARTISAN_OPEN_ON_MAKE_EDITOR != "" ]]; then
            # Find and open files created by artisan
            find \
                "$laravel_path/app" \
                "$laravel_path/tests" \
                "$laravel_path/database" \
                -type f \
                -newermt "-$((`date +%s` - $artisan_start_time + 1)) seconds" \
                -exec $ARTISAN_OPEN_ON_MAKE_EDITOR {} \; 2>/dev/null
        fi

        return $artisan_exit_status
    }

    compdef _artisan_add_completion artisan

    function _artisan_find() {
        # Look for artisan up the file tree until the root directory
        local dir=.
        until [ $dir -ef / ]; do
            if [ -f "$dir/artisan" ]; then
                echo "$dir/artisan"
                return 0
            fi

            dir+=/..
        done

        return 1
    }

    function _artisan_add_completion() {
        if [ "`_artisan_find`" != "" ]; then
            compadd `_artisan_get_command_list`
        fi
    }

    function _artisan_get_command_list() {
        artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"
    }

    function _docker_compose_cmd() {
        docker compose &> /dev/null
        if [ $? = 0 ]; then
            echo "docker compose"
        else
            echo "docker-compose"
        fi
    }
  '';
}
