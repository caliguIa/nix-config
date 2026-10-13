# Keep only the declared extensions' toolbar buttons out of the extensions
# panel. Input is the parsed browser.uiCustomization.state, $declared is
# {pinned: [widget ids]}. Every other widget and area is left as it is.
def isAction: endswith("-browser-action");
def uniq: reduce .[] as $w ([]; if index($w) == null then . + [$w] else . end);

$declared[0].pinned as $pin
| def keep: select(isAction | not) // select(. as $w | $pin | index($w) != null);
  (.placements // {}) as $pl
| ($pl | keys_unsorted | map(select(. != "unified-extensions-area"))) as $areas
# Buttons to park in the panel: the panel's own, then those found elsewhere.
| ([ ($pl["unified-extensions-area"] // [])[], ($areas[] as $a | $pl[$a][]) ]
   | map(select(isAction and (. as $w | $pin | index($w) == null))) | uniq) as $parked
| ([ $areas[] as $a | $pl[$a][] ]) as $placed
| .placements |= (
    with_entries(.value |= map(keep))
    | if ($parked | length) > 0
      then .["unified-extensions-area"] = ((.["unified-extensions-area"] // []) + $parked | uniq)
      else . end
    | if has("nav-bar")
      then reduce $pin[] as $w (.;
          if ($placed | index($w)) == null
          then .["unified-extensions-area"] |= (. // [] | map(select(. != $w)))
               | .["nav-bar"] += [$w]
          else . end)
      else . end)
