{
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        lib,
        ...
    }: {
        accounts.calendar.basePath = "${config.xdg.dataHome}/calendars";
        accounts.calendar.accounts.personal = {
            primary = true;
            primaryCollection = "personal";
            remote = {
                userName = "cal@calrichards.io";
                passwordCommand = ["sh" "-c" "${pkgs.coreutils}/bin/cat ${config.age.secrets.token-fastmail-vdirsyncer-caldav.path}"];
                url = "https://caldav.fastmail.com";
                type = "caldav";
            };
            local = {
                type = "filesystem";
                fileExt = ".ics";
            };
            vdirsyncer = {
                enable = true;
                # Config, Remote, Local
                collections = [["personal" "3D630590-BDBA-11F0-B7A7-64A7CEEA34EB" "personal"]];
                conflictResolution = "remote wins";
                metadata = ["color" "displayname" "description" "order"];
            };
            khal = {
                enable = true;
                type = "discover";
            };
            qcal.enable = true; # trying out
        };

        services.vdirsyncer.enable = true;
        programs.vdirsyncer.enable = true;

        # Put this calendar account on vdirsyncer's radar
        systemd.user.services.vdirsyncer.Service.ExecStart = lib.mkBefore [
            (lib.getExe (pkgs.writeShellApplication {
                name = "vdirsyncer-discover-calendar";
                runtimeInputs = [pkgs.vdirsyncer];
                text = "yes | vdirsyncer discover calendar_personal || true";
            }))
        ];

        programs.qcal.enable = true;
        programs.khal = {
            enable = true;
            settings = {
                default = {
                    default_calendar = "personal";
                    default_event_alarm = "15m";
                    default_event_duration = "30m";
                    highlight_event_days = true;
                    show_all_days = true; # show days without events too
                    timedelta = "7d"; # show 1 week into the future
                };
                keybindings = {
                    external_edit = "e";
                    export = "w";
                    save = "meta w,<0>";
                    view = "enter, ";
                };
                highlight_days = {
                    method = "fg";
                    multiple = "#0000FF";
                    multiple_on_overflow = true;
                };
                view = {
                    dynamic_days = false;
                    event_view_always_visible = true;
                    frame = "color";
                };
            };
        };
    };
}
