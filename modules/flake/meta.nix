{
    _module.args.user = {
        primary = "caligula";
        media = "media";
    };
    # A path, so each secret copies only its own file into the store.
    _module.args.secret = name: ../../.secrets + "/${name}.age";
}
