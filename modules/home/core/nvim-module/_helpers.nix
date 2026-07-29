# Shared helpers for the nvim-module seed files and generator.
#
# mkKeymap / mkAutocmd produce a mkLuaInline value wrapping a complete
# vim.keymap.set / vim.api.nvim_create_autocmd expression. Because they return
# a raw-Lua marker, they can be used anywhere a Lua value is expected: inside a
# plugin's `keymaps`/`extraLua`, or standalone.
{lib}: let
    inherit (lib.generators) mkLuaInline;
    toLua = lib.generators.toLua {};

    # Build the opts table for a keymap from its normalised fields.
    keymapOpts = m:
        {
            silent = m.silent or true;
        }
        // lib.optionalAttrs ((m.desc or null) != null) {desc = m.desc;}
        // lib.optionalAttrs (m.expr or false) {expr = true;}
        // lib.optionalAttrs (m.remap or false) {remap = true;}
        // lib.optionalAttrs (m.buffer or false) {buffer = true;}
        // (m.opts or {});

    # Produce the raw `vim.keymap.set(...)` Lua expression (a string).
    keymapExpr = m: "vim.keymap.set(${toLua (m.mode or "n")}, ${toLua m.lhs}, ${toLua m.rhs}, ${toLua (keymapOpts m)})";

    # Produce the raw `vim.api.nvim_create_autocmd(...)` Lua expression.
    autocmdExpr = a: let
        spec =
            lib.optionalAttrs ((a.group or null) != null) {
                group = mkLuaInline "vim.api.nvim_create_augroup(${toLua a.group}, { clear = true })";
            }
            // lib.optionalAttrs ((a.pattern or null) != null) {pattern = a.pattern;}
            // lib.optionalAttrs ((a.desc or null) != null) {desc = a.desc;}
            // lib.optionalAttrs ((a.callback or null) != null) {callback = a.callback;}
            // lib.optionalAttrs ((a.command or null) != null) {command = a.command;};
    in "vim.api.nvim_create_autocmd(${toLua a.event}, ${toLua spec})";
in {
    inherit keymapExpr autocmdExpr keymapOpts;

    # mkRaw alias for convenience in seed files.
    mkRaw = mkLuaInline;

    # Marker-wrapped versions for use as Lua values.
    mkKeymap = m: mkLuaInline (keymapExpr m);
    mkAutocmd = a: mkLuaInline (autocmdExpr a);
}
