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
    ];
}
