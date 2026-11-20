# Containers, spaces and their pins, shared by Zen (as spaces and pins) and
# Firefox (as bookmark folders whose links open in the space's container).
rec {
    # Container identities, keyed by name and upserted by userContextId.
    containers = {
        personal = {
            userContextId = 1;
            icon = "fingerprint";
            color = "blue";
        };
        work = {
            userContextId = 2;
            icon = "briefcase";
            color = "orange";
        };
    };

    # Spaces and their pins, in order. A pin's name is optional, without one
    # the page title shows. The uuids are the ones already in the Zen session
    # so nothing is duplicated. Spaces or pins made by hand are kept.
    spaces = [
        {
            name = "Personal";
            uuid = "{2b56123b-1a7b-4ae1-86d0-772550400b79}";
            icon = "chrome://browser/skin/zen-icons/selectable/star.svg";
            container = containers.personal.userContextId;
            essentials = [ ];
            pins = [
                {
                    name = "Fastmail";
                    url = "https://app.fastmail.com/";
                }
                {
                    name = "GitHub";
                    url = "https://github.com/";
                }
                {
                    name = "Claude";
                    url = "https://claude.ai/new";
                }
                {
                    name = "NixOS Search";
                    url = "https://search.nixos.org/packages?channel=unstable";
                }
            ];
        }
        {
            name = "Work";
            uuid = "{1b61faf2-584f-47b5-ba3c-bb25d28841b0}";
            icon = "chrome://browser/skin/zen-icons/selectable/briefcase.svg";
            container = containers.work.userContextId;
            essentials = [ ];
            pins = [
                {
                    name = "GitHub";
                    url = "https://github.com/";
                }
                {
                    name = "Claude";
                    url = "https://claude.ai/new";
                }
                {
                    name = "Gmail";
                    url = "https://mail.google.com";
                }
                {
                    name = "Calendar";
                    url = "https://calendar.google.com";
                }
            ];
        }
        {
            name = "Music";
            uuid = "{e9f6d757-a46f-4248-b06b-500890ae5859}";
            icon = "chrome://browser/skin/zen-icons/selectable/music.svg";
            container = containers.personal.userContextId;
            essentials = [ ];
            pins = [
                {
                    name = "Miniflux Music";
                    url = "https://rss.calrichards.io/category/12/feeds";
                }
                {
                    name = "slskd";
                    url = "https://slsk.smiley.calrichards.io";
                }
                {
                    name = "Navidrome";
                    url = "https://music.smiley.calrichards.io";
                }
                {
                    name = "ListenBrainz";
                    url = "https://listenbrainz.org/user/caIigula/";
                }
                {
                    name = "Sounds of the Universe";
                    url = "https://soundsoftheuniverse.com/";
                }
                {
                    name = "Phonica";
                    url = "https://www.phonicarecords.com/";
                }
                {
                    name = "Boomkat";
                    url = "https://boomkat.com/";
                }
                {
                    name = "Juno Records";
                    url = "https://www.juno.co.uk/";
                }
                {
                    name = "Bandcamp";
                    url = "https://bandcamp.com/";
                }
                {
                    name = "Hard Wax";
                    url = "https://hardwax.com/";
                }
            ];
        }
    ];
}
