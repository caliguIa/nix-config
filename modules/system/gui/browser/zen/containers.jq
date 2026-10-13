# Upsert the declared identities into containers.json by userContextId.
# Existing identities keep every other field (l10nId, name, ...), undeclared
# ones are kept, and `version` and `siteAssociations` are left alone.
$declared[0] as $d
| .identities = (
    reduce $d.containers[] as $c ((.identities // []);
        if any(.[]; .userContextId == $c.userContextId)
        then map(if .userContextId == $c.userContextId
                 then . + { icon: $c.icon, color: $c.color, public: true }
                 else . end)
        else . + [{ userContextId: $c.userContextId, public: true,
                    icon: $c.icon, color: $c.color, name: $c.name }]
        end))
# 4294967295 is the webext storage sentinel, not a real id.
| .lastUserContextId = ([ (.lastUserContextId // 0),
                          (.identities | map(.userContextId | select(. < 4294967295)) | max // 0) ] | max)
