{
    flake.modules.nixos.host_smiley =
        {
            pkgs,
            config,
            ...
        }:
        let
            stagingDir = "/var/backup/restic";
            pg = config.services.postgresql.package;
            runuser = "${pkgs.util-linux}/bin/runuser";
            forgejo = config.services.forgejo;
            forgejoDb = "${forgejo.stateDir}/data/forgejo.db";
            karakeepDb = "/var/lib/karakeep/db.db";
        in
        {
            systemd.tmpfiles.rules = [
                "d /var/backup 0700 root root -"
                "d ${stagingDir} 0700 root root -"
            ];

            services.restic.backups.smiley-state = {
                environmentFile = config.age.secrets.restic-r2.path;

                initialize = true;

                paths = [
                    "/var/lib/jellyfin" # users, watch history, playback positions
                    "/var/lib/navidrome" # play counts, playlists, starred
                    "/var/lib/audiobookshelf" # listening progress + users
                    "/var/lib/calibre-web" # users, shelves, read status (app.db)
                    "/data/media/books/metadata.db" # calibre library catalogue
                    "/data/media/books/users.sqlite" # calibre-server auth
                    "/data/photos/library" # immich originals (irreplaceable)
                    "/data/photos/upload" # immich in-flight uploads
                    "/data/photos/profile" # immich user avatars
                    "/data/files/documents" # personal docs
                    "/etc/ssh/ssh_host_ed25519_key" # so a rebuilt smiley can
                    "/etc/ssh/ssh_host_ed25519_key.pub" # decrypt agenix without re-keying
                    "${forgejo.repositoryRoot}" # git repos (the actual content)
                    "${forgejo.stateDir}/data" # lfs, attachments, avatars, packages, actions
                    "${forgejo.customDir}" # app.ini + SECRET_KEY/INTERNAL_TOKEN/JWT
                    "/var/lib/uptime-kuma" # monitors, notifications, users
                    "/var/lib/karakeep/settings.env" # MEILI_MASTER_KEY + NEXTAUTH_SECRET (irreplaceable)
                    "/var/lib/karakeep/assets" # saved screenshots, images, PDFs
                    stagingDir # Postgres dumps + consistent SQLite copies (Forgejo, Karakeep)
                ];

                exclude = [
                    "/var/lib/navidrome/cache"
                    "/var/lib/jellyfin/transcodes"
                    "/var/lib/jellyfin/metadata" # re-fetchable artwork/nfo
                    "/data/photos/thumbs" # immich thumbnails, regenerated from originals
                    "/data/photos/encoded-video" # immich transcodes, regenerated
                    # Live SQLite files: backed up separately as a consistent
                    # .backup snapshot in the staging dir, so skip the torn live
                    # copies here.
                    "${forgejoDb}"
                    "${forgejoDb}-wal"
                    "${forgejoDb}-shm"
                    "${forgejo.stateDir}/data/tmp" # transient scratch
                    "${forgejo.stateDir}/data/queues" # regenerable work queues
                    "${forgejo.stateDir}/data/sessions" # login sessions, non-critical
                    "${forgejo.stateDir}/data/indexers" # rebuildable search indexes
                ];

                extraBackupArgs = [
                    "--exclude-caches"
                    "--tag=smiley-state"
                ];

                backupPrepareCommand = ''
                    set -euo pipefail
                    umask 077
                    ${runuser} -u postgres -- ${pg}/bin/pg_dump -Fc miniflux > ${stagingDir}/miniflux.dump
                    ${runuser} -u postgres -- ${pg}/bin/pg_dump -Fc immich > ${stagingDir}/immich.dump

                    # Consistent online snapshot of Forgejo's SQLite database.
                    # `.backup` is safe against the live WAL database and avoids
                    # capturing a torn forgejo.db/-wal/-shm set. Run as root: it
                    # can read the mode-0027 db and write the copy into the
                    # root-owned staging dir. restic then backs up the snapshot.
                    ${pkgs.sqlite}/bin/sqlite3 ${forgejoDb} ".backup '${stagingDir}/forgejo.db'"

                    # Same consistent-snapshot treatment for Karakeep's SQLite
                    # database (bookmarks, tags, lists, highlights). The
                    # Meilisearch index is regenerable from this, so it is not
                    # backed up.
                    ${pkgs.sqlite}/bin/sqlite3 ${karakeepDb} ".backup '${stagingDir}/karakeep.db'"
                '';

                pruneOpts = [
                    "--keep-daily 7"
                    "--keep-weekly 5"
                    "--keep-monthly 12"
                ];

                # Verify repository integrity after each backup+prune. Structural
                # check (index/metadata/pack listing) plus a rotating 5% sample of
                # actual pack data read back from R2 to catch silent bit-rot,
                # keeping egress modest. A non-empty checkOpts auto-enables the
                # check step in the same restic-backups-smiley-state run.
                checkOpts = [
                    "--read-data-subset=5%"
                ];

                timerConfig = {
                    OnCalendar = "03:00";
                    RandomizedDelaySec = "45min";
                    Persistent = true;
                };
            };
        };
}
