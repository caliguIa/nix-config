{
    flake.modules.nixos.host_smiley =
        { pkgs, ... }:
        {
            # Bookmark/read-later hoarder. The NixOS module self-generates its
            # own MEILI_MASTER_KEY and NEXTAUTH_SECRET into
            # /var/lib/karakeep/settings.env on first boot, so no agenix secret
            # is needed for basic operation. To enable AI auto-tagging, add an
            # OPENAI_API_KEY (or Ollama config) via an environmentFile.
            #
            # Runs web + workers + Meilisearch + a headless Chromium (for
            # screenshots), all native. Fronted by Caddy on the tailnet.
            services.karakeep = {
                enable = true;
                # The default nixpkgs karakeep builds better-sqlite3 against
                # Node 24, whose native module crashes on prepared-statement
                # finalization during GC (node::RemoveEnvironmentCleanupHook
                # assertion -> SIGABRT), which crash-loops the web/workers and
                # leaves the queue tables uncreated ("no such table: tasks").
                # Build against Node 22 LTS, which is stable with this
                # better-sqlite3.
                # package = pkgs.karakeep.override { nodejs = pkgs.nodejs_22; };
                # Text search backend.
                meilisearch.enable = true;
                # Headless Chromium for full-page screenshots/archival.
                browser.enable = true;
                extraEnvironment = {
                    # Forgejo already owns :3000, so move Karakeep off it.
                    PORT = "3333";
                    NEXTAUTH_URL = "https://bookmarks.smiley.calrichards.io";
                    DISABLE_NEW_RELEASE_CHECK = "true";
                };
            };
        };
}
