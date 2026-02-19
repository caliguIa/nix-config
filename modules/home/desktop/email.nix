# https://wilw.dev/notes/aerc
{
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        ...
    }: {
        accounts.email.maildirBasePath = "${config.xdg.dataHome}/mail";
        accounts.email.accounts.personal = {
            userName = "cal@calrichards.io";
            passwordCommand = ["${pkgs.coreutils}/bin/cat ${config.age.secrets.token-fastmail-mbsync.path}"];
            primary = true;
            realName = "Cal";
            address = "cal@calrichards.io";
            flavor = "fastmail.com";
            maildir.path = "personal";
            aerc = {
                enable = true;
                extraAccounts = {
                    address-book-cmd = "${pkgs.khard}/bin/khard email -a personal --parsable --remove-first-line %s";
                    cache-headers = true;
                    cache-state = true;
                    cache-blobs = true;
                    check-mail = "2m";
                    check-mail-cmd = "${pkgs.isync}/bin/mbsync personal && ${pkgs.notmuch}/bin/notmuch new";
                    check-mail-timeout = "30s";
                    copy-to = "Sent";
                    default = "Inbox";
                    maildir-store = "${config.xdg.dataHome}/mail";
                    maildir-account-path = "personal";
                    source = "notmuch://${config.xdg.dataHome}/mail";
                    use-labels = true;
                };
            };
            mbsync = {
                enable = true;
                extraConfig.channel = {
                    Sync = "All"; # default is all, push and pull changes
                    Create = "Near"; # default is both, only create local dirs
                    Expunge = "Both"; # default is both, delete both sides
                    CopyArrivalDate = "yes"; # default is no, yes to avoid duplicates
                    SyncState = "*"; # store syncstate inside each mailbox
                };
                extraConfig.account.TLSType = "IMAPS";
            };
            notmuch.enable = true;
            imapnotify = {
                enable = true;
                boxes = ["Inbox"];
                onNotifyPost = "${pkgs.libnotify}/bin/notify-send '[Personal] New Mail'";
            };
        };

        programs.aerc = {
            enable = true;
            extraConfig = {
                general.unsafe-accounts-conf = true;
                ui = {
                    fuzzy-complete = true;
                    icon-new = "";
                    icon-attachment = "󰁦";
                    icon-old = "";
                    icon-replied = "";
                    icon-flagged = "";
                    icon-deleted = "";
                    reverse-thread-order = true;
                    threading-enabled = true;
                    show-thread-context = true;
                    this-day-time-format = ''"           15:04"'';
                    this-year-time-format = "Mon Jan 02 15:04";
                    timestamp-format = "2006-01-02 15:04";
                    spinner = "[ ⡿ ],[ ⣟ ],[ ⣯ ],[ ⣷ ],[ ⣾ ],[ ⣽ ],[ ⣻ ],[ ⢿ ]";
                    border-char-vertical = "┃";
                    border-char-horizontal = "━";
                };
                viewer = {always-show-mime = true;};
                compose = {no-attachment-warning = "^[^>]*attach(ed|ment)";};
                filters = {
                    "text/plain" = "colorize";
                    "text/html" = "pandoc -f html -t plain";
                    "text/calendar" = "calendar";
                    "message/delivery-status" = "colorize";
                    "message/rfc822" = "colorize";
                    "image/*" = "${pkgs.catimg}/bin/catimg -";
                    ".headers" = "colorize";
                };
                multipart-converters = {
                    "text/html" = "pandoc -f markdown -t html --standalone";
                };
            };
            extraBinds = {
                global = {
                    "<C-p>" = ":prev-tab<Enter>";
                    "<C-n>" = ":next-tab<Enter>";
                    "?" = ":help keys<Enter>";
                };
                messages = {
                    "h" = ":prev-tab<Enter>";
                    "l" = ":next-tab<Enter>";

                    "j" = ":next<Enter>";
                    "<Down>" = ":next<Enter>";
                    "<C-d>" = ":next 50%<Enter>";
                    "<C-f>" = ":next 100%<Enter>";
                    "<PgDn>" = ":next 100%<Enter>";

                    "k" = ":prev<Enter>";
                    "<Up>" = ":prev<Enter>";
                    "<C-u>" = ":prev 50%<Enter>";
                    "<C-b>" = ":prev 100%<Enter>";
                    "<PgUp>" = ":prev 100%<Enter>";
                    "g" = ":select 0<Enter>";
                    "G" = ":select -1<Enter>";

                    "J" = ":next-folder<Enter>";
                    "K" = ":prev-folder<Enter>";
                    "H" = ":collapse-folder<Enter>";
                    "L" = ":expand-folder<Enter>";

                    "v" = ":mark -t<Enter>";
                    "x" = ":mark -t<Enter>:next<Enter>";
                    "V" = ":mark -v<Enter>";

                    "T" = ":toggle-threads<Enter>";

                    "<Enter>" = ":view<Enter>";
                    "d" = ":prompt 'Really delete this message?' 'delete-message'<Enter>";
                    "D" = ":delete<Enter>";
                    "A" = ":archive flat<Enter>";

                    "C" = ":compose<Enter>";

                    "rr" = ":reply -a<Enter>";
                    "rq" = ":reply -aq<Enter>";
                    "Rr" = ":reply<Enter>";
                    "Rq" = ":reply -q<Enter>";

                    "c" = ":cf<space>";
                    "$" = ":term<space>";
                    "!" = ":term<space>";
                    "|" = ":pipe<space>";

                    "/" = ":search<space>";
                    "\\" = ":filter<space>";
                    "n" = ":next-result<Enter>";
                    "N" = ":prev-result<Enter>";
                    "<Esc>" = ":clear<Enter>";
                };

                "messages:folder=Inbox" = {
                    a = ":archive flat<Enter>";
                    A = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>";
                };
                "messages:folder=Archive" = {
                    u = ":tag -archived +inbox<Enter>:move Inbox<Enter>";
                };
                "messages:folder=Drafts" = {"<Enter>" = ":recall<Enter>";};
                view = {
                    "/" = ":toggle-key-passthrough<Enter>/";
                    "q" = ":close<Enter>";
                    "O" = ":open<Enter>";
                    "S" = ":save<space>";
                    "|" = ":pipe<space>";
                    "D" = ":delete<Enter>";
                    "A" = ":archive flat<Enter>";

                    "<C-l>" = ":open-link <space>";

                    "f" = ":forward<Enter>";
                    "rr" = ":reply -a<Enter>";
                    "rq" = ":reply -aq<Enter>";
                    "Rr" = ":reply<Enter>";
                    "Rq" = ":reply -q<Enter>";

                    "H" = ":toggle-headers<Enter>";
                    "<C-k>" = ":prev-part<Enter>";
                    "<C-j>" = ":next-part<Enter>";
                    "J" = ":next<Enter>";
                    "K" = ":prev<Enter>";
                };

                "view::passthrough" = {
                    "$noinherit" = true;
                    "$ex" = "<C-x>";
                    "<Esc>" = ":toggle-key-passthrough<Enter>";
                };

                compose = {
                    "$noinherit" = "true";
                    "$ex" = "<C-x>";
                    "<C-k>" = ":prev-field<Enter>";
                    "<C-j>" = ":next-field<Enter>";
                    "<A-p>" = ":switch-account -p<Enter>";
                    "<A-n>" = ":switch-account -n<Enter>";
                    "<tab>" = ":next-field<Enter>";
                    "<C-p>" = ":prev-tab<Enter>";
                    "<C-n>" = ":next-tab<Enter>";
                };

                "compose::editor" = {
                    "$noinherit" = "true";
                    "$ex" = "<C-x>";
                    "<C-k>" = ":prev-field<Enter>";
                    "<C-j>" = ":next-field<Enter>";
                    "<C-p>" = ":prev-tab<Enter>";
                    "<C-n>" = ":next-tab<Enter>";
                };

                "compose::review" = {
                    "y" = ":send<Enter>";
                    "n" = ":abort<Enter>";
                    "p" = ":postpone<Enter>";
                    "q" = ":choose -o d discard abort -o p postpone postpone<Enter>";
                    "e" = ":edit<Enter>";
                    "a" = ":attach<space>";
                    "d" = ":detach<space>";
                };

                terminal = {
                    "$noinherit" = "true";
                    "$ex" = "<C-x>";

                    "<C-p>" = ":prev-tab<Enter>";
                    "<C-n>" = ":next-tab<Enter>";
                };
            };
        };

        programs.mbsync.enable = true;
        services.mbsync.enable = true;
        services.imapnotify.enable = true;

        programs.notmuch = {
            enable = true;
            extraConfig = {
                user = {
                    name = "Cal Richards";
                    primary_email = "cal@calrichards.io";
                };
                new = {
                    tags = "unread;inbox;";
                    ignore = "";
                };
                search.exclude_tags = "deleted;spam;";
                maildir.synchronize_flags = "true";
            };
            new.ignore = [
                ".uidvalidity"
                ".mbsyncstate"
                ".sync-if-1"
            ];
            hooks.preNew = ''
                ${pkgs.notmuch}/bin/notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm -v
                ${pkgs.isync}/bin/mbsync -Va
            '';
            hooks.postNew = ''
                ${pkgs.notmuch}/bin/notmuch tag +personal "folder:/personal/"
                ${pkgs.notmuch}/bin/notmuch tag +sent "folder:/personal/Sent/" and not tag:sent
                ${pkgs.notmuch}/bin/notmuch tag +spam "folder:/personal/Spam/" and not tag:spam
                ${pkgs.notmuch}/bin/notmuch tag +archived "folder:/personal/Archive/" and not tag:archived
                ${pkgs.notmuch}/bin/notmuch tag -new tag:new
            '';
        };
        home.packages = with pkgs; [pandoc];

        xdg.desktopEntries.email = {
            name = "Email";
            genericName = "Email client";
            comment = "Terminal email client";
            exec = "${pkgs.kitty}/bin/kitty -e aerc";
            icon = "aerc";
            terminal = false;
            type = "Application";
            categories = ["Email" "Network"];
            mimeType = ["x-scheme-handler/mailto"];
        };
    };
}
