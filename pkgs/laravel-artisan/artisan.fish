function __artisan_first_arg
    test (count (commandline -opc)) -eq 1
end

complete -c artisan -n __artisan_first_arg -f -a '(artisan --commands 2>/dev/null)'
complete -c artisan -n __artisan_first_arg -f -l commands -d 'List artisan commands (cached)'
complete -c artisan -n __artisan_first_arg -f -l refresh -d 'Rebuild the artisan command cache'
complete -c artisan -n '__fish_seen_argument -l commands' -f -l json -d 'Output as JSON'
