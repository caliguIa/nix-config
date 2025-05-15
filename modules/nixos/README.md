# NixOS Configuration

This directory contains the NixOS-specific configuration for the system.

## Structure

- `default.nix`: Main entry point that imports all modules
- `services/`: Directory containing individual service configurations
  - `openssh.nix`: SSH server configuration
  - `jellyfin.nix`: Jellyfin media server configuration
  - `sabnzbd.nix`: SABnzbd download client configuration
  - `audiobookshelf.nix`: Audiobookshelf server configuration
  - `cloudflared.nix`: Cloudflare Tunnel configuration
  - `auto-standby.nix`: Automatic standby configuration
  - `samba.nix`: Samba file sharing configuration
- `users.nix`: User and group configuration
- `packages.nix`: System packages configuration

## Hardware Configuration

The system is configured to use the hardware-configuration.nix directly from its installed location at `/etc/nixos/hardware-configuration.nix`, so there's no need to copy this file.

To use this configuration on your server:

1. Boot into the NixOS installation media
2. Install NixOS with `nixos-install`
3. Clone this repository to a location like `/home/caligula/nix-config`
4. Build and apply the configuration with `nixos-rebuild switch --flake .#george`

## Notes

- The Samba service requires running `sudo smbpasswd -a <username>` to set up user access
- Cloudflare Tunnel credentials must be properly configured on the server