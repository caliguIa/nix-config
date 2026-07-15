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

    restic-smiley-state snapshots   # generated wrapper, auto-sources creds
    restic-smiley-state check
