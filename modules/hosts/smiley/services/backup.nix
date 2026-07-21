{
    flake.modules.nixos.host_smiley = {
        pkgs,
        config,
        ...
    }: let
        stagingDir = "/var/backup/restic";
        pg = config.services.postgresql.package;
        runuser = "${pkgs.util-linux}/bin/runuser";
    in {
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
                stagingDir # miniflux Postgres dump (see prepare cmd)
            ];

            exclude = [
                "/var/lib/navidrome/cache"
                "/var/lib/jellyfin/transcodes"
                "/var/lib/jellyfin/metadata" # re-fetchable artwork/nfo
                "/data/photos/thumbs" # immich thumbnails, regenerated from originals
                "/data/photos/encoded-video" # immich transcodes, regenerated
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
            '';

            pruneOpts = [
                "--keep-daily 7"
                "--keep-weekly 5"
                "--keep-monthly 12"
            ];

            timerConfig = {
                OnCalendar = "03:00";
                RandomizedDelaySec = "45min";
                Persistent = true;
            };
        };
    };
}
