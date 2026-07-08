{
    flake.modules.nixos.host_smiley = {
        pkgs,
        config,
        ...
    }: let
        # Local staging area for consistent DB snapshots that can't just be
        # file-copied live (Postgres). restic then backs up the dump alongside
        # the service state dirs.
        stagingDir = "/var/backup/restic";
        pg = config.services.postgresql.package;
        runuser = "${pkgs.util-linux}/bin/runuser";
    in {
        systemd.tmpfiles.rules = [
            "d /var/backup 0700 root root -"
            "d ${stagingDir} 0700 root root -"
        ];

        services.restic.backups.smiley-state = {
            # Repo URL + R2 (S3) credentials + repo password all live in this
            # single agenix env file, so nothing R2-specific lands in git:
            #   RESTIC_REPOSITORY=s3:https://<accountid>.r2.cloudflarestorage.com/<bucket>
            #   RESTIC_PASSWORD=<random>
            #   AWS_ACCESS_KEY_ID=<r2 access key id>
            #   AWS_SECRET_ACCESS_KEY=<r2 secret access key>
            # (The module allows repository/passwordFile to be unset when an
            # environmentFile is provided.)
            environmentFile = config.age.secrets.restic-r2.path;

            initialize = true;

            # The state worth keeping - everything here is effort that can't be
            # re-downloaded, unlike the media itself. A few GB total, well
            # inside R2's free tier.
            paths = [
                "/var/lib/jellyfin" # users, watch history, playback positions
                "/var/lib/navidrome" # play counts, playlists, starred
                "/var/lib/audiobookshelf" # listening progress + users
                "/var/lib/calibre-web" # users, shelves, read status (app.db)
                "/data/media/books/metadata.db" # calibre library catalogue
                "/data/media/books/users.sqlite" # calibre-server auth
                "/etc/ssh/ssh_host_ed25519_key" # so a rebuilt smiley can
                "/etc/ssh/ssh_host_ed25519_key.pub" # decrypt agenix without re-keying
                stagingDir # miniflux Postgres dump (see prepare cmd)
            ];

            # Regenerable caches - excluded to keep the repo lean.
            exclude = [
                "/var/lib/navidrome/cache"
                "/var/lib/jellyfin/transcodes"
                "/var/lib/jellyfin/metadata" # re-fetchable artwork/nfo
            ];

            extraBackupArgs = [
                "--exclude-caches"
                "--tag=smiley-state"
            ];

            # Dump the miniflux Postgres DB to the staging dir before the run.
            # Peer auth: run pg_dump as the postgres OS/superuser role. Custom
            # (-Fc) format so it restores cleanly with pg_restore. The service
            # state dirs are SQLite and copied raw - fine at this write volume,
            # and restic keeps history if one snapshot is ever torn.
            backupPrepareCommand = ''
                set -euo pipefail
                umask 077
                ${runuser} -u postgres -- ${pg}/bin/pg_dump -Fc miniflux > ${stagingDir}/miniflux.dump
            '';

            # Keep a decent ladder without unbounded growth.
            pruneOpts = [
                "--keep-daily 7"
                "--keep-weekly 5"
                "--keep-monthly 12"
            ];

            # Nightly, jittered, and catch up if smiley was off at the scheduled
            # time.
            timerConfig = {
                OnCalendar = "03:00";
                RandomizedDelaySec = "45min";
                Persistent = true;
            };
        };
    };
}
