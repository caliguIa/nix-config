; extends

; Inject Lua into the string argument of mkRaw / mkLuaInline so nvim-module's
; embedded Lua snippets get Lua highlighting without a `# lua` marker comment.
(apply_expression
  function: (_) @_func
  argument: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
  ]
  (#lua-match? @_func "mkRaw$")
  (#set! injection.combined))

(apply_expression
  function: (_) @_func
  argument: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
  ]
  (#lua-match? @_func "mkLuaInline$")
  (#set! injection.combined))
