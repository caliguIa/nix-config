# Maps every file under `dir` to a hjem `files` entry under ~/.config/nvim, so
# the core and dev trees merge file by file instead of fighting over directories.
# Not autoimported (leading underscore).
{ lib }:
dir:
lib.listToAttrs (
    map (file: {
        name = ".config/nvim/${lib.removePrefix "./" (lib.path.removePrefix dir file)}";
        value.source = file;
    }) (lib.filesystem.listFilesRecursive dir)
)
