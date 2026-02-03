{
    flake.modules.homeManager.desktop-linux-kickoff = {
        config,
        pkgs,
        ...
    }: {
        programs.kickoff = {
            enable = true;
            settings = {
                fonts = [config.stylix.fonts.monospace.name];
                font-size = 32;
                prompt = "> ";
                padding = 100;
                search.show_hidden_files = false;
                history.decrease_interval = 48;
                keybindings = {
                    paste = ["ctrl+v" "ctrl+shift+v"];
                    execute = ["KP_Enter" "Return" "ctrl+y"];
                    delete = ["KP_Delete" "Delete" "BackSpace"];
                    delete_word = ["ctrl+KP_Delete" "ctrl+Delete" "ctrl+BackSpace"];
                    complete = ["Tab" "Left" "ctrl+Left"];
                    nav_up = ["Up" "ctrl+Up" "ctrl+p"];
                    nav_down = ["Down" "ctrl+Down" "ctrl+n"];
                    exit = ["Escape" "ctrl+c"];
                };
                colors = let
                    colours = config.lib.stylix.colors;
                in {
                    background = "#${colours.base01}aa";
                    prompt = "#${colours.base06}";
                    text = "#${colours.base07}";
                    text_query = "#${colours.base07}";
                    text_selected = "#${colours.base0A}";
                };
            };
        };
        home.packages = let
            mkCmdRunner = cmd: "${pkgs.ghostty}/bin/ghostty -e ${cmd}";
            mkOpen = url: "${pkgs.xdg-utils}/bin/xdg-open ${url}";
            mkFirefoxPWA = appId: "firefoxpwa site launch ${appId}";
            nhBin = "${pkgs.nh}/bin/nh";
            nixpkgsSearch = pkgs.writeShellScriptBin "kickoff-nixpkgs-search" ''
                sleep 0.1
                ${pkgs.kickoff}/bin/kickoff --from-file ${
                    pkgs.writeText "nixpkgs-kickoff-entries" (
                        builtins.concatStringsSep "\n" (
                            builtins.map
                            (name: "${name} = echo -n '${name}' | ${pkgs.wl-clipboard}/bin/wl-copy")
                            (builtins.attrNames pkgs)
                        )
                    )
                } "$@"
            '';
        in [
            (pkgs.writeShellScriptBin "kickoff-programs" ''
                custom_entries=$(cat <<'EOF'
                    clipboard history = sleep 0.1 && kickoff-clipvault
                    docs nixos = ${mkOpen "https://search.nixos.org/options?channel=unstable"}
                    docs home-manager = ${mkOpen "https://home-manager-options.extranix.com/?release=master"}
                    docs nix-darwin = ${mkOpen "https://nix-darwin.github.io/nix-darwin/manual/"}
                    foot = ${pkgs.foot}/bin/foot
                    finder = ${pkgs.nautilus}/bin/nautilus
                    firefox = ${pkgs.firefox}/bin/firefox
                    ghostty = ${pkgs.ghostty}/bin/ghostty
                    glide = glide
                    nix switch = ${mkCmdRunner "${nhBin} os switch"}
                    nix build = ${mkCmdRunner "${nhBin} os build"}
                    nix gc = ${mkCmdRunner "${nhBin} clean all"}
                    nix gc root = ${mkCmdRunner "sudo ${nhBin} clean all"}
                    nix update = ${mkCmdRunner "${pkgs.nix}/bin/nix flake update --flake ~/nix-config && echo 'Press any key to exit...' && read -n 1"}
                    nixpkgs = ${nixpkgsSearch}/bin/kickoff-nixpkgs-search
                    poweroff = poweroff
                    reboot = reboot
                    slack = ${mkFirefoxPWA "01K902TKNCJT4KVWV1HP92CGZ9"}
                    wlogout = ${pkgs.wlogout}/bin/wlogout
                EOF)
                echo "$custom_entries" | ${pkgs.kickoff}/bin/kickoff --from-stdin "$@"
            '')
        ];
    };
}
