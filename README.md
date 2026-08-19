# nix-config

Personal NixOS configuration built on flake-parts using the dendritic pattern.

## Structure

```
flake.nix                 # entrypoint
lib/recursivelyImport.nix # custom autoimporter
modules/
  flake/                  # flake-parts wiring
  hosts/                  # per-host modules
  system/core/            # base modules for every host
  system/desktop/         # modules for graphical hosts
  zmk/                    # ZMK split keyboard firmware
.secrets/                 # agenix-encrypted secrets
```

## Dendritic pattern

Every `.nix` file under `modules/` is a flake-parts module, autoimported by
`lib/recursivelyImport.nix`. Files whose basename starts with `_` are skipped.

Rather than defining config directly, modules contribute to named buckets:

- `flake.modules.{nixos,hjem}.{core,desktop,host_<name>}`

flake-parts merges these definitions, so many files can each append to the same
bucket. Hosts compose the buckets they need via `imports`.

## Hosts

Defined in `modules/flake/hosts.nix`. Each maps to a platform and composes core
and/or desktop buckets.

- `karla` (x86_64) - Framework 16 laptop, desktop
- `westerby` (aarch64) - Apple Silicon M1 Macbook Air, desktop
- `smiley` (x86_64) - Mac Mini server, core only

## Home / dotfiles

Uses [hjem](https://github.com/feel-co/hjem) (not home-manager). Dotfile
modules populate `flake.modules.hjem.*` and are imported per-user in
`modules/system/core/hjem.nix`.

## Secrets

Managed with [agenix](https://github.com/ryantm/agenix). Encrypted `.age` files
live in `.secrets/`; recipients are declared in `.secrets/secrets.nix`.

## Dev shell

`nix develop` (or direnv) provides helper scripts: `update`, `pin`, `rb`,
`deploy`, `zmk`.
