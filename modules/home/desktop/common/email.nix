{
    flake.modules.homeManager.desktop = {
        pkgs,
        config,
        ...
    }: let
        contactsDir = "${config.xdg.dataHome}/share/contacts/personal";
        mailDir = "${config.home.homeDirectory}/Maildir";
    in {
        home.packages = with pkgs; [
            khard
            vdirsyncer
            pandoc
        ];
        programs.aerc.enable = true;
        programs.mbsync.enable = true;
        programs.notmuch = {
            enable = true;
            extraConfig = {
                database.path = "${mailDir}";
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
            hooks.postNew = ''
                # Reference Maildir folders for tagging
                notmuch tag +calrichards "folder:/calrichards/"
                # Handle sent and spam mail by IMAP folders
                notmuch tag +sent "folder:/Sent/" and not tag:sent
                notmuch tag +spam "folder:/Spam/" and not tag:spam
                notmuch tag +archived "folder:/calrichards/Archive/" and not tag:archived
                # Remove the new tag from all new emails
                notmuch tag -new tag:new
            '';
        };
        services.vdirsyncer.enable = true;
        xdg.configFile."vdirsyncer/config".text =
            # toml
            ''
                [general]
                status_path = "${config.xdg.configHome}/vdirsyncer/status/"
                [pair personal_addressbook]
                a = "personal_addressbook_local"
                b = "personal_addressbook_remote"
                collections = ["from a", "from b"]
                metadata = ["displayname"]
                [storage personal_addressbook_local]
                type = "filesystem"
                path = "${contactsDir}"
                fileext = ".vcf"
                [storage personal_addressbook_remote]
                type = "carddav"
                auth = "basic"
                url = "https://carddav.fastmail.com/dav/addressbooks/user/cal@caligula.io/Default"
                username = "cal@calrichards.io"
                password.fetch = ["command", "op", "item", "get", "aydqjt2af4k3ymcdsgwwij7nw4", "--field", "credential", "--reveal"]
            '';
        xdg.configFile."khard/khard.conf".text =
            # toml
            ''
                [addressbooks]
                [[personal]]
                path = "${contactsDir}/Default"
            '';
        xdg.configFile."aerc/accounts.conf".text =
            # toml
            ''
                [calrichards]
                source               = notmuch://${mailDir}
                query-map            = ${config.xdg.configHome}/aerc/map.conf
                outgoing             = smtps://cal%40calrichards.io@smtp.fastmail.com:465
                maildir-store        = ${mailDir}
                maildir-account-path = calrichards
                outgoing-cred-cmd    = op item get rf6ogfumkjzvkeh4eyirbpv5r4 --field credential --reveal
                check-mail-cmd       = ${(pkgs.writeScriptBin "mail-sync"
                #sh
                ''
                    MBSYNC=$(pgrep mbsync)
                    NOTMUCH=$(pgrep notmuch)

                    if [ -n "$MBSYNC" -o -n "$NOTMUCH" ]; then
                        echo "Already running one instance of mbsync or notmuch. Exiting..."
                        exit 0
                    fi

                    echo "Deleting messages tagged as *deleted*"
                    notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm -v

                    mbsync -Va
                    notmuch new
                '')}/bin/mail-sync
                check-mail           = 2m
                check-mail-timeout   = 30s
                default              = Inbox
                from                 = Cal Richards <cal@calrichards.io>
                cache-headers        = true
                use-labels           = true;
                cache-headers        = true;
                cache-state          = true;
                cache-blobs          = true;
                copy-to              = Sent
                address-book-cmd     = khard email -a personal --parsable --remove-first-line %s
            '';
        xdg.configFile."aerc/aerc.conf".text =
            # toml
            ''
                [general]
                unsafe-accounts-conf = true
                default-save-path=${config.home.homeDirectory}/Downloads
                log-file=${config.home.homeDirectory}/.local/state/aerc/aerc.log

                [ui]
                fuzzy-complete=true
                archive=+archived -inbox
                icon-new=✨
                icon-attachment=📎
                icon-old=🕰️
                icon-replied=📝
                icon-flagged=🚩
                icon-deleted=🗑️

                [viewer]
                alternatives=text/plain,text/html
                header-layout=From,To,Cc,Bcc,Date,Subject

                [compose]
                header-layout=From,To,Cc,Subject
                reply-to-self=false
                empty-subject-warning=true
                no-attachment-warning=^[^>]*attach(ed|ment)

                [multipart-converters]
                text/html=pandoc -f markdown -t html --standalone

                [filters]
                text/html=pandoc -f html -t plain
                text/plain=colorize
                text/calendar=calendar
                message/delivery-status=colorize
                message/rfc822=colorize
                .headers=colorize

                [openers]
                [statusline]
                [hooks]
                [templates]
            '';
        xdg.configFile."aerc/binds.conf".text = ''
            # Binds are of the form <key sequence> = <command to run>
            # To use '=' in a key sequence, substitute it with "Eq": "<Ctrl+Eq>"
            # If you wish to bind #, you can wrap the key sequence in quotes: "#" = quit
            <C-p> = :prev-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgDn> = :next-tab<Enter>
            \[t = :prev-tab<Enter>
            \]t = :next-tab<Enter>
            <C-t> = :term<Enter>
            ? = :help keys<Enter>
            <C-c> = :prompt 'Quit?' quit<Enter>
            <C-q> = :prompt 'Quit?' quit<Enter>
            <C-z> = :suspend<Enter>

            [messages]
            q = :prompt 'Quit?' quit<Enter>

            j = :next<Enter>
            <Down> = :next<Enter>
            <C-d> = :next 50%<Enter>
            <C-f> = :next 100%<Enter>
            <PgDn> = :next 100%<Enter>

            k = :prev<Enter>
            <Up> = :prev<Enter>
            <C-u> = :prev 50%<Enter>
            <C-b> = :prev 100%<Enter>
            <PgUp> = :prev 100%<Enter>
            g = :select 0<Enter>
            G = :select -1<Enter>

            J = :next-folder<Enter>
            <C-Down> = :next-folder<Enter>
            K = :prev-folder<Enter>
            <C-Up> = :prev-folder<Enter>
            H = :collapse-folder<Enter>
            <C-Left> = :collapse-folder<Enter>
            L = :expand-folder<Enter>
            <C-Right> = :expand-folder<Enter>

            v = :mark -t<Enter>
            <Space> = :mark -t<Enter>:next<Enter>
            V = :mark -v<Enter>

            T = :toggle-threads<Enter>
            zc = :fold<Enter>
            zo = :unfold<Enter>
            za = :fold -t<Enter>
            zM = :fold -a<Enter>
            zR = :unfold -a<Enter>
            <tab> = :fold -t<Enter>

            zz = :align center<Enter>
            zt = :align top<Enter>
            zb = :align bottom<Enter>

            <Enter> = :view<Enter>
            d = :choose -o y 'Really delete this message' delete-message<Enter>
            D = :delete<Enter>
            a = :archive flat<Enter>
            u = :tag -archived +inbox<Enter>:move Inbox<Enter>
            A = :unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>

            C = :compose<Enter>
            m = :compose<Enter>

            b = :bounce<space>

            rr = :reply -a<Enter>
            rq = :reply -aq<Enter>
            Rr = :reply<Enter>
            Rq = :reply -q<Enter>

            c = :cf<space>
            $ = :term<space>
            ! = :term<space>
            | = :pipe<space>

            / = :search<space>
            \ = :filter<space>
            n = :next-result<Enter>
            N = :prev-result<Enter>
            <Esc> = :clear<Enter>

            s = :split<Enter>
            S = :vsplit<Enter>

            pl = :patch list<Enter>
            pa = :patch apply <Tab>
            pd = :patch drop <Tab>
            pb = :patch rebase<Enter>
            pt = :patch term<Enter>
            ps = :patch switch <Tab>

            [messages:folder=Drafts]
            <Enter> = :recall<Enter>


            [view]
            / = :toggle-key-passthrough<Enter>/
            q = :close<Enter>
            O = :open<Enter>
            o = :open<Enter>
            S = :save<space>
            | = :pipe<space>
            D = :delete<Enter>
            A = :archive flat<Enter>

            <C-y> = :copy-link <space>
            <C-l> = :open-link <space>

            f = :forward<Enter>
            rr = :reply -a<Enter>
            rq = :reply -aq<Enter>
            Rr = :reply<Enter>
            Rq = :reply -q<Enter>

            H = :toggle-headers<Enter>
            <C-k> = :prev-part<Enter>
            <C-Up> = :prev-part<Enter>
            <C-j> = :next-part<Enter>
            <C-Down> = :next-part<Enter>
            J = :next<Enter>
            <C-Right> = :next<Enter>
            K = :prev<Enter>
            <C-Left> = :prev<Enter>

            [view::passthrough]
            $noinherit = true
            $ex = <C-x>
            <Esc> = :toggle-key-passthrough<Enter>

            [compose]
            # Keybindings used when the embedded terminal is not selected in the compose
            # view
            $noinherit = true
            $ex = <C-x>
            $complete = <C-o>
            <C-k> = :prev-field<Enter>
            <C-Up> = :prev-field<Enter>
            <C-j> = :next-field<Enter>
            <C-Down> = :next-field<Enter>
            <A-p> = :switch-account -p<Enter>
            <C-Left> = :switch-account -p<Enter>
            <A-n> = :switch-account -n<Enter>
            <C-Right> = :switch-account -n<Enter>
            <tab> = :next-field<Enter>
            <backtab> = :prev-field<Enter>
            <C-p> = :prev-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgDn> = :next-tab<Enter>

            [compose::editor]
            # Keybindings used when the embedded terminal is selected in the compose view
            $noinherit = true
            $ex = <C-x>
            <C-k> = :prev-field<Enter>
            <C-Up> = :prev-field<Enter>
            <C-j> = :next-field<Enter>
            <C-Down> = :next-field<Enter>
            <C-p> = :prev-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgDn> = :next-tab<Enter>

            [compose::review]
            # Keybindings used when reviewing a message to be sent
            # Inline comments are used as descriptions on the review screen
            y = :send<Enter> # Send
            n = :abort<Enter> # Abort (discard message, no confirmation)
            s = :sign<Enter> # Toggle signing
            x = :encrypt<Enter> # Toggle encryption to all recipients
            v = :preview<Enter> # Preview message
            p = :postpone<Enter> # Postpone
            q = :choose -o d discard abort -o p postpone postpone<Enter> # Abort or postpone
            e = :edit<Enter> # Edit (body and headers)
            a = :attach<space> # Add attachment
            d = :detach<space> # Remove attachment

            [terminal]
            $noinherit = true
            $ex = <C-x>

            <C-p> = :prev-tab<Enter>
            <C-n> = :next-tab<Enter>
            <C-PgUp> = :prev-tab<Enter>
            <C-PgDn> = :next-tab<Enter>
        '';
        xdg.configFile."aerc/map.conf".text = ''
            Inbox=not tag:archived and not tag:deleted and not tag:spam
            Archive=tag:archived
            Sent=tag:sent
            Spam=tag:spam
        '';
        xdg.configFile."isyncrc".text = ''
            IMAPAccount calrichards
            Host imap.fastmail.com
            Port 993
            User cal@calrichards.io
            PassCmd "op item get rf6ogfumkjzvkeh4eyirbpv5r4 --field credential --reveal"
            TLSType IMAPS
            SystemCertificates yes

            IMAPStore calrichards-remote
            Account calrichards

            MaildirStore calrichards-local
            Path ${mailDir}/calrichards/
            Inbox ${mailDir}/calrichards/Inbox
            SubFolders Verbatim

            Channel calrichards
            Far :calrichards-remote:
            Near :calrichards-local:
            Patterns *
            Expunge None
            CopyArrivalDate yes
            Sync All
            SyncState *
            Create Both
        '';
    };
}
