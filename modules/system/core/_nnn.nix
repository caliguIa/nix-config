# nnn build shared by the system package (nnn.nix) and helix's picker.
# Not autoimported (leading underscore); import with `import ./_nnn.nix { inherit pkgs; }`.
{ pkgs }:
(pkgs.nnn.override { withNerdIcons = true; }).overrideAttrs (old: {
    # nnn has no flag or env var to start with the built-in preview pane (`P`)
    # open, so flip its compiled-in default. `P` still toggles it.
    postPatch = (old.postPatch or "") + ''
        substituteInPlace src/nnn.c \
            --replace-fail $'\t.rollover = 1,\n};' $'\t.rollover = 1,\n\t.preview = 1,\n};'
    '';
})
