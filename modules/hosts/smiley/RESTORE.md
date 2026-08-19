# Recovery

Backups: restic repo `smiley-state` in Cloudflare R2 (`services.restic.backups`
in `modules/hosts/smiley/services/backup.nix`). Nightly, encrypted client-side.

## Restore data (no NixOS or agenix required)

agenix is never needed to read the backup. Use the restic CLI directly.

    export RESTIC_REPOSITORY=s3:https://...
    export RESTIC_PASSWORD=... AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=...

    restic snapshots
    restic restore latest --target /restore

Restore into a staging dir (`/restore`), never straight onto `/`.

Miniflux Postgres (custom-format dump):

    systemctl stop miniflux
    runuser -u postgres -- pg_restore -d miniflux --clean --if-exists \
        /restore/var/backup/restic/miniflux.dump
    systemctl start miniflux

Immich Postgres (custom-format dump). The pgvector/vectorchord extensions are
provisioned by the `services.immich` module, so they already exist after a
switch. Restore metadata then the originals:

    systemctl stop immich-server immich-machine-learning
    runuser -u postgres -- pg_restore -d immich --clean --if-exists \
        /restore/var/backup/restic/immich.dump
    rsync -a /restore/data/photos/ /data/photos/   # library, upload, profile
    systemctl start immich-server immich-machine-learning

Photos live at `/data/photos` (originals under `library/`); `thumbs/` and
`encoded-video/` are excluded from backup and regenerate on first access.

Forgejo (git forge, SQLite). Data restored: `repositories/` (all repos and
commits), `data/` (LFS, issue/PR/release attachments, avatars, packages, Actions
artifacts) and `custom/` (`app.ini` plus `SECRET_KEY`/`INTERNAL_TOKEN`/JWT
secrets, so existing sessions and tokens survive). The live `forgejo.db` is
excluded from the file backup; a consistent `.backup` snapshot is staged instead
(`/var/backup/restic/forgejo.db`). Restore order matters:

    systemctl stop forgejo
    rsync -a --delete /restore/var/lib/forgejo/repositories/ /var/lib/forgejo/repositories/
    rsync -a --delete /restore/var/lib/forgejo/data/        /var/lib/forgejo/data/
    rsync -a --delete /restore/var/lib/forgejo/custom/      /var/lib/forgejo/custom/
    # load the consistent DB snapshot; ensure no stale WAL/SHM linger
    rm -f /var/lib/forgejo/data/forgejo.db-wal /var/lib/forgejo/data/forgejo.db-shm
    install -m600 /restore/var/backup/restic/forgejo.db /var/lib/forgejo/data/forgejo.db
    chown -R forgejo:forgejo /var/lib/forgejo
    systemctl start forgejo

The excluded `data/{tmp,queues,sessions,indexers}` are transient/regenerable;
search indexes rebuild automatically on start. SSH git remains tailnet-only
(port 2222 on `tailscale0`); the public HTTPS URL is served by the cloudflared
tunnel and needs `cloudflared-git` present for `git.calrichards.io` to resolve.

## Restore a single service

    restic restore latest --target /restore --include /var/lib/jellyfin
    systemctl stop jellyfin
    rsync -a --delete /restore/var/lib/jellyfin/ /var/lib/jellyfin/
    systemctl start jellyfin

## Rebuild smiley from scratch

Two paths to make agenix decrypt again. The host key is what decrypts NixOS
secrets (`age.identityPaths` defaults to `/etc/ssh/ssh_host_ed25519_key`).

### A. Reuse the old host key (no re-key)

1. Install NixOS, bring up networking.
2. Restore the saved host key before the first switch. NixOS will not overwrite
   an existing host key, so this must precede step 3.

        install -m600 <old-key>     /etc/ssh/ssh_host_ed25519_key
        install -m644 <old-key>.pub /etc/ssh/ssh_host_ed25519_key.pub

3. `nixos-rebuild switch --flake .#smiley`. agenix decrypts (identity matches a
   recipient in `.secrets/secrets.nix`); `restic-r2` is available.
4. Restore data (sections above); restart affected services.

### B. Fresh host key (re-key)

1. Install NixOS; let it generate a new host key; bring up networking.
2. From a machine holding an editing key, replace `systems.smiley` in
   `.secrets/secrets.nix` with the new pubkey
   (`cat /etc/ssh/ssh_host_ed25519_key.pub`), then re-encrypt all secrets:

        cd .secrets && agenix -r

3. Commit and deploy: `nixos-rebuild switch --flake .#smiley`.
4. Restore data (sections above).

## Health checks

Integrity is verified automatically: the nightly `restic-backups-smiley-state`
service runs `restic check --read-data-subset=5%` after each backup+prune, so a
rotating sample of pack data is read back from R2 (structural metadata is always
checked). A failure shows up in that unit's journal/status:

    systemctl status restic-backups-smiley-state
    journalctl -u restic-backups-smiley-state

Manual checks (generated wrapper, auto-sources creds):

    restic-smiley-state snapshots
    restic-smiley-state check                    # structure only
    restic-smiley-state check --read-data        # full data verification (high R2 egress)
