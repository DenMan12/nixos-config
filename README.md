# NixOS Configuration (Niri + Noctalia + ArtCraft)

Declarative NixOS config for spdmrf's laptop.

## Structure

- `flake.nix` — inputs (nixpkgs, home-manager, millennium) and system configuration
- `configuration.nix` — system-level settings (Niri, Steam, networking, etc.)
- `home.nix` — user-level settings (Noctalia, dotfiles, user packages)
- `hardware-configuration.nix` — hardware-specific config (will be regenerated on real hardware)
- `pkgs/artcraft/` — custom derivations for ArtCraft suite (GridCraft, WordCraft, PDFCraft, PhotoCraft)

## Stack

- **Display:** Niri (Wayland scrollable tiling)
- **Panel:** Noctalia
- **Gaming:** Steam + Millennium mod framework
- **Productivity:** ArtCraft suite (open-source Office/Adobe alternatives)
- **Apps:** Obsidian, Zen browser, qBittorrent, Yazi, Neovim, btop, rmpc+mpd, Rnote, Loaf

## Building

### Test in VM (no installation)

```bash
# First time: generate flake.lock
nix flake update

# Build VM
nixos-rebuild build-vm --flake .#nixos

# Run (will create ./result/bin/run-nixos-vm)
./result/bin/run-nixos-vm
```

**Note for Niri in VM:** Needs 3D acceleration. Pass `-vga virtio -display gtk,gl=on` to QEMU or use libvirt with virgl.

### Install on real hardware

1. Boot NixOS Live USB
2. Partition disk, mount to `/mnt`
3. Generate hardware config:
   ```bash
   nixos-generate-config --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix
   ```
4. Copy this repo to `/mnt/etc/nixos/`
5. Replace the placeholder `hardware-configuration.nix` with the generated one
6. Install:
   ```bash
   nixos-install --flake /mnt/etc/nixos#nixos
   ```

## TODO

- [ ] Fix ArtCraft derivation URLs (see `pkgs/artcraft/*.nix` — replace placeholder URLs and sha256)
- [ ] Copy actual Noctalia config from Arch to `home.nix`
- [ ] Check if `zen-browser` package exists in nixpkgs (might be `zen` or need manual derivation)
- [ ] Verify `loaf` package name
- [ ] Replace git email in `home.nix`
- [ ] Test VM boot with Niri
- [ ] Port Niri config from Arch (either as file or convert to `programs.niri.settings`)

## Rollback

```bash
# List generations
nixos-rebuild list-generations

# Rollback to previous
nixos-rebuild switch --rollback

# Boot into specific generation (from GRUB menu)
```

## Sources

- [ArtCraft suite info](https://artcraftdownload.com/)
- [storytold/wordcraft](https://github.com/storytold/wordcraft)
- [Millennium Steam mod](https://github.com/SteamClientHomebrew/Millennium)
