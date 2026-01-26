{
    flake.modules.homeManager.desktop-linux-wlogout = {
        pkgs,
        lib,
        ...
    }: {
        programs.wlogout = {
            enable = true;
            package = pkgs.symlinkJoin {
                name = "wlogout-wrapped";
                paths = [pkgs.wlogout];
                buildInputs = [pkgs.makeWrapper];
                postBuild = ''wrapProgram $out/bin/wlogout --add-flags "--show-binds --buttons-per-row 2"'';
            };
            layout = lib.mkForce [
                {
                    label = "reboot";
                    action = "systemctl reboot";
                    text = "Restart";
                    keybind = "r";
                }
                {
                    label = "shutdown";
                    action = "systemctl poweroff";
                    text = "Shutdown";
                    keybind = "s";
                }
                {
                    label = "lock";
                    action = "hyprlock";
                    text = "Lock";
                    keybind = "l";
                }
                {
                    label = "logout";
                    action = "swaymsg exit";
                    text = "Logout";
                    keybind = "e";
                }
            ];
            style = pkgs.writeText "wlogout-style.css" ''
                * {
                	background-image: none;
                	box-shadow: none;
                }
                window {
                	background-color: rgba(20, 23, 29, 0.8);
                }
                button {
                    border-radius: 4;
                	text-decoration-color: #f2f1ef;
                    color: #f2f1ef;
                	background-color: #22262D;
                	background-repeat: no-repeat;
                	background-position: center;
                	background-size: 25%;
                }
                button:focus, button:active, button:hover {
                	background-color: #393B44;
                	outline-style: none;
                }
                #lock {
                    background-image: image(url("${./assets/lock.png}"));
                }
                #logout {
                    background-image: image(url("${./assets/logout.png}"));
                }
                #shutdown {
                    background-image: image(url("${./assets/poweroff.png}"));
                }
                #reboot {
                    background-image: image(url("${./assets/reboot.png}"));
                }
            '';
        };
    };
}
