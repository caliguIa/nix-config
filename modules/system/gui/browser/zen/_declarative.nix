# Pre-launch merge of declared containers, spaces and pins into a Zen profile.
# Zen keeps these in profile files it rewrites itself (containers.json,
# zen-sessions.jsonlz4), so they are merged in rather than symlinked.
{
    pkgs,
    lib,
    containers,
    spaces,
    pinnedWidgets,
}:
let
    spaceList = lib.imap0 (position: space: space // { inherit position; }) spaces;

    # Pins get a stable id from their space, kind and URL, so the merge can tell
    # a declared pin from one the user made by hand.
    mkPin = space: essential: pin: {
        inherit essential;
        inherit (pin) url;
        name = pin.name or null;
        id = "nix-${
            builtins.substring 0 16 (
                builtins.hashString "sha256" "${space.uuid}${if essential then "essential" else "pin"}${pin.url}"
            )
        }";
        workspace = space.uuid;
        container = space.container;
    };

    pinList = lib.concatMap (
        space: map (mkPin space false) space.pins ++ map (mkPin space true) space.essentials
    ) spaceList;

    duplicates = lib.filter (id: lib.count (pin: pin.id == id) pinList > 1) (map (pin: pin.id) pinList);

    declaredSession = pkgs.writeText "zen-declared-session.json" (
        builtins.toJSON {
            spaces = map (s: {
                inherit (s)
                    uuid
                    name
                    icon
                    container
                    position
                    ;
            }) spaceList;
            pins = pinList;
        }
    );

    declaredContainers = pkgs.writeText "zen-declared-containers.json" (
        builtins.toJSON {
            containers = lib.mapAttrsToList (name: c: c // { inherit name; }) containers;
        }
    );
    declaredToolbar = pkgs.writeText "zen-declared-toolbar.json" (
        builtins.toJSON { pinned = pinnedWidgets; }
    );
in
lib.throwIf (duplicates != [ ])
    "zen: a pin is declared twice in one space (${toString (lib.unique duplicates)})"
    (
        pkgs.writeShellApplication {
            name = "zen-declarative";
            runtimeInputs = with pkgs; [
                coreutils
                gawk
                jq
                lsof
                mozlz4a
            ];
            text = ''
                export ZEN_SESSION_JQ=${./session.jq}
                export ZEN_CONTAINERS_JQ=${./containers.jq}
                export ZEN_DECLARED_SESSION=${declaredSession}
                export ZEN_DECLARED_CONTAINERS=${declaredContainers}
                export ZEN_TOOLBAR_JQ=${./toolbar.jq}
                export ZEN_DECLARED_TOOLBAR=${declaredToolbar}
                ${builtins.readFile ./prelaunch.sh}
            '';
        }
    )
