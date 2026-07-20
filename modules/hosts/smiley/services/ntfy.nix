{
    flake.modules.nixos.host_smiley = {pkgs, ...}: let
        listen = "127.0.0.1:2586";

        # Publish a notification to an ntfy topic.
        #   ntfy-publish <topic> <title> <tags> <message>
        ntfyPublish = pkgs.writeShellApplication {
            name = "ntfy-publish";
            runtimeInputs = [pkgs.curl];
            text = ''
                topic="$1"; title="$2"; tags="$3"; message="$4"
                curl -fsS --max-time 10 \
                    -H "Title: $title" \
                    -H "Tags: $tags" \
                    -d "$message" \
                    "http://${listen}/$topic" >/dev/null \
                    || echo "ntfy-publish: notification failed (non-fatal)" >&2
            '';
        };
    in {
        _module.args.ntfyPublish = ntfyPublish;

        services.ntfy-sh = {
            enable = true;
            settings = {
                base-url = "https://ntfy.smiley.calrichards.io";
                listen-http = listen;
                behind-proxy = true;
            };
        };
    };
}
