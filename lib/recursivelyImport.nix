{ lib }:
let
    inherit (lib) hasSuffix hasPrefix;
    inherit (builtins)
        concatMap
        isPath
        filter
        readFileType
        ;

    expandIfFolder =
        elem:
        if !isPath elem || readFileType elem != "directory" then
            [ elem ]
        else
            lib.filesystem.listFilesRecursive elem;
in
list:
filter (
    elem:
    !isPath elem || (hasSuffix ".nix" (toString elem) && !hasPrefix "_" (baseNameOf (toString elem)))
) (concatMap expandIfFolder list)
