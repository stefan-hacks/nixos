# ❄️ NixOS Fleet Configuration

> Flake-based NixOS with Home Manager. Multi-host, multi-layer modular system
> for **titan**, **ghost**, **minimal**, and **server** — managed entirely
> through Nix expressions.

---

## Installing from NixOS Minimal ISO (Blank SSD)

This is the priority install path for a fresh machine. After install, all
configuration is declarative — no manual file edits.

### 1. Boot the NixOS minimal installer

Download the latest NixOS minimal ISO, write to USB, boot, and set up
networking:

```bash
# Set a password for the nixos user so you can SSH in if needed
passwd

# Identify your target disk
lsblk
# Note the device, e.g. /dev/nvme0n1
```

### 2. Partition and format with Disko

Disko handles partitioning declaratively. Each host has a `disko-config.nix`.

| Host | Disko template | Layout |
|------|---------------|--------|
| **titan** | `hosts/titan/disko-config.nix` | LUKS + LVM (`cryptroot` UUID `8a350d7a-ce96-4ba6-938c-61b2739239f6`) |
| **ghost** | `hosts/ghost/disko-config.nix` | Same LUKS+LVM (shares cryptroot UUID with titan) |
| **minimal** | `hosts/minimal/disko-config.nix` | Simple ext4, no LUKS |
| **server** | `hosts/server/disko-config.nix` | Simple ext4, no LUKS |

**Edit the host's disko template** to set the `device` to your real disk:

```bash
nano hosts/titan/disko-config.nix
# Change: device = "/dev/nvme0n1";
```

**Uncomment the disko imports** in the host's `default.nix`:

```bash
nano hosts/titan/default.nix
# Uncomment these two lines:
# inputs.disko.nixosModules.disko
# ./disko-config.nix
```

**Run disko** to partition, format, and mount:

```bash
# From the NixOS installer:
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko -- \
  --mode destroy,format,mount ./hosts/<host>/disko-config.nix
```

> ⚠️ **This erases the entire target disk.**

### 3. Generate hardware configuration

```bash
# Tell nixos-generate-config NOT to write filesystems — disko already handled them.
sudo nixos-generate-config --no-filesystems --root /mnt
```

### 4. Copy your configuration and install

```bash
# Copy your repo into the target mount
sudo mkdir -p /mnt/etc/nixos
sudo cp -r ~/.config/nixos/* /mnt/etc/nixos/

# Copy the generated hardware config into the host directory
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/<host>/

# Install NixOS
sudo nixos-install --flake /mnt/etc/nixos#<host>
```

### 5. Set passwords and reboot

```bash
# Set password for the primary user
sudo nixos-enter --root /mnt
passwd stefan-hacks
exit

# Reboot into the new system
reboot
```

### 6. Post-install cleanup

After first boot, **re-comment** the disko import lines in the host's
`default.nix`. From now on, rebuild with flakes:

```bash
cd ~/.config/nixos
sudo nixos-rebuild switch --flake .#<host>
```

---

## Daily Rebuild Commands

```bash
cd ~/.config/nixos

# Dry-run build (no activation)
nixos-rebuild build --flake .#titan

# Activate on current machine
sudo nixos-rebuild switch --flake .#titan

# Update all flake inputs and rebuild
nix flake update
sudo nixos-rebuild switch --flake .#titan

# Verify all four host configs
nix flake check
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│  flake.nix                                                          │
│  ├── inputs: nixpkgs (26.05), home-manager (release-26.05),        │
│  │          nvf, nixdatifier, nix-graph, nix-flatpak,             │
│  │          vellum, kitty-scrollback, treefmt-nix                   │
│  └── outputs: nixosConfigurations.{titan,ghost,minimal,server}       │
│                                                                     │
│  HOST (hosts/<host>/default.nix)                                    │
│  ├── hardware-configuration.nix                                   │
│  ├── disko-config.nix  (initial install only)                     │
│  └── imports → system.nix                                           │
│                                                                     │
│  SYSTEM (system.nix)                                                │
│  ├── system-level/  ──→  boot, desktop, audio, networking,        │
│  │                         packages, flatpak, security,            │
│  │                         maintenance, theming, virtualization    │
│  └── users.users.stefan-hacks                                       │
│                                                                     │
│  USER (home-manager)                                                │
│  └── user-level/home-manager/stefan-hacks/                          │
│      ├── programs/  ──→  bash (ble.sh + vi mode + aliases),        │
│      │                     kitty, starship, atuin, zoxide,         │
│      │                     carapace, helix, zellij, fastfetch, git   │
│      └── gnome/     ──→  dconf modules (nix-my-gnome generated)     │
└─────────────────────────────────────────────────────────────────────┘
```

**Design principle:** `system.nix` is the shared OS entry point. Home Manager
handles all per-user dotfiles and program configuration. Host files are thin
wrappers.

---

## Current Flake Inputs

| Input | URL | Branch/Tag | Purpose |
|-------|-----|------------|---------|
| `nixpkgs` | `github:NixOS/nixpkgs/nixos-26.05` | stable | Primary package set |
| `home-manager` | `github:nix-community/home-manager/release-26.05` | stable | Per-user dotfiles + programs |
| `nvf` | `github:NotAShelf/nvf` | main | Declarative Neovim (replaces lazyvim-nix) |
| `nixdatifier` | `github:Muddyblack/nixdatifier` | master | NixOS desktop widget + TUI |
| `nix-graph` | `github:AlexAntonik/nix-graph` | default | Interactive Nix dependency graph TUI |
| `nix-flatpak` | `github:gmodena/nix-flatpak/?ref=latest` | latest | Declarative system-wide flatpaks |
| `vellum` | `github:blackhat-7/vellum.nvim` | — | Extra nvim plugin |
| `kitty-scrollback` | `github:mikesmithgh/kitty-scrollback.nvim/v8.0.0` | v8.0.0 | Kitty scrollback nvim plugin |
| `treefmt-nix` | `github:numtide/treefmt-nix` | main | Tree-wide formatter |

> **Stable-first policy:** All inputs use nixos-26.05 / release-26.05 where
> available. GUI applications that need fresher versions are managed via
> declarative flatpaks instead of unstable overlays.

---

## Repository Structure

```
~/.config/nixos/
├── flake.nix                       # Flake inputs + nixosConfigurations
├── system.nix                      # Shared OS entry point
├── README.md                       # You are here
│
├── hosts/                          # Per-machine entry points
│   ├── titan/
│   │   ├── default.nix             # Host config: amdgpu, LUKS, hostname
│   │   ├── hardware-configuration.nix
│   │   ├── sensors.nix             # k10temp (AZW SER limitation: no fan)
│   │   └── disko-config.nix        # LUKS + LVM layout
│   ├── ghost/
│   │   ├── default.nix             # LUKS (shares cryptroot UUID with titan)
│   │   ├── hardware-configuration.nix
│   │   └── disko-config.nix
│   ├── minimal/
│   │   ├── default.nix             # Bare-minimum host
│   │   ├── hardware-configuration.nix
│   │   └── disko-config.nix        # Simple ext4, no LUKS
│   └── server/
│       ├── default.nix             # Headless server host
│       ├── hardware-configuration.nix
│       └── disko-config.nix        # Simple ext4, no LUKS
│
├── system-level/                   # Shared OS modules
│   ├── boot.nix                    # systemd-boot, kernel, initrd
│   ├── nix-settings.nix            # nix daemon, experimental-features, GC
│   ├── desktop.nix                 # GNOME, GDM, services.displayManager
│   ├── theming.nix                 # GDM wallpaper, Plymouth, catppuccin
│   ├── audio.nix                   # PipeWire, Bluetooth audio
│   ├── networking.nix              # NetworkManager, firewall basics
│   ├── firewall.nix                # nftables rules
│   ├── fail2ban.nix                # Intrusion prevention
│   ├── bluetooth.nix               # BlueZ, resume fix for IMC 13d3:3621
│   ├── locale.nix                  # Timezone, locale, keymap
│   ├── logging.nix                 # Journal settings
│   ├── maintenance.nix             # Auto-upgrade, nix.gc
│   ├── programs.nix                # fzf, mtr, gnupg
│   ├── services.nix                # Printing, kanata
│   ├── virtualization.nix          # QEMU/KVM, virt-manager
│   ├── packages.nix                # System-wide packages
│   ├── nvf.nix                     # Declarative Neovim (nvf) config
│   ├── flatpak.nix                 # Declarative system-wide flatpak apps
│   └── ...
│
└── user-level/home-manager/stefan-hacks/   # HM user config
    ├── default.nix                 # HM entry point
    ├── programs/
    │   ├── bash.nix                # ble.sh, vi mode, aliases, atuin, zoxide
    │   ├── kitty.nix               # Kitty terminal (shell_integration disabled for ble.sh)
    │   ├── starship.nix            # Prompt
    │   ├── atuin.nix               # Shell history sync
    │   ├── carapace.nix            # Multi-shell argument completion
    │   ├── helix.nix               # evil-helix config
    │   ├── zellij.nix              # Raw KDL config
    │   ├── fastfetch.nix           # JSONC config
    │   └── git.nix                 # Git user.name, user.email
    └── gnome/                      # dconf modules (nix-my-gnome generated)
```

---

## How It Works

### Three Layers

| Layer | File(s) | What lives here |
|-------|---------|-----------------|
| **Host** | `hosts/<host>/default.nix`, `hardware-configuration.nix` | Hardware, LUKS, GPU drivers, hostname, per-host imports |
| **System** | `system.nix` + `system-level/*.nix` | OS-wide settings: boot, desktop, audio, network, packages, services, security |
| **User** | `user-level/home-manager/stefan-hacks/**/*.nix` | Dotfiles, program configs, shell aliases, GNOME dconf |

### Home Manager Integration

Each host wires Home Manager via `flake.nix`:

```nix
home-manager = {
  useGlobalPkgs = true;
  useUserPackages = true;
  backupFileExtension = "backup";
  extraSpecialArgs = {inherit inputs;};
  users.stefan-hacks = import ../../user-level/home-manager/stefan-hacks;
};
```

All user config is declarative — no manual `~/.bashrc` edits. Changes are
activated on rebuild via `home-manager-stefan-hacks.service`.

### Shell Stack (all user-level via Home Manager)

| Tool | Role | Integration Notes |
|------|------|-------------------|
| **ble.sh** | Bash line editor + vi mode | Sourced in `bashrcExtra`. `unset -f read` removes its read wrapper to prevent conflicts with carapace/fzf completions. |
| **atuin** | Shell history sync | Initialised AFTER `ble-attach` in initExtra. Detects `BLE_ATTACHED` and registers ble.sh-compatible widgets. `ATUIN_CONFIG_DIR` exported for non-login shells. |
| **zoxide** | Smart cd | Initialised in initExtra via `zoxide init bash`. |
| **carapace** | Multi-shell argument completion | `carapace _carapace bash` sourced in initExtra. |
| **starship** | Prompt | `starship init bash` in initExtra, guarded by `TERM != "dumb"`. |
| **fzf** | Fuzzy finder | `fzf --bash` in initExtra. |

### Neovim (nvf)

Neovim is configured via [nvf](https://github.com/NotAShelf/nvf) as a Home
Manager module (replaced lazyvim-nix):

- **Theme:** catppuccin-mocha
- **Features:** LSP, treesitter, nvim-cmp completion, debugger (DAP)
- **Languages:** Nix (nixd/alejandra), Rust, Bash, YAML, JSON, TOML, Markdown,
  HTML, Ansible, Terraform
- **Extras:** telescope, neo-tree, gitsigns, lualine
- **Aliases:** `v` → `nvim`, `nv` → `nvim`, `EDITOR=nvim`
- **Config:** `system-level/nvf.nix`

### Bash Aliases

The `bash.nix` module provides aliases folded from multiple categories:

- **Shell** — `..`, `...`, `c`, `e`, `h`, `j`, `lg`, `src`
- **Nix/NixOS** — `nsw`, `nbd`, `nfu`, `nfc`, `nfmt`, `ndiff`, `ngc`, `nroots`, `nrepair`
- **Git** — `g`, `gs`, `ga`, `gco`, `gcb`, `gl`, `gd`, `gundo`, `gprune`
- **Docker/Podman** — `dps`, `dex`, `dlogs`, `dc`, `dcu`, `dcd`
- **Kubernetes** — `k`, `kgp`, `kgn`, `kd`, `kl`, `kaf`, `kctx`, `kns`
- **Systemd** — `sctl`, `scts`, `sctr`, `jrn`, `jrnb`, `jrnf`
- **Networking** — `ipa`, `ports`, `ss`, `dnsq`, `curl-time`
- **Infra** — `tf`, `tfv`, `ap`, `api`

See `user-level/home-manager/stefan-hacks/programs/bash.nix` for the full list.

---

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Flakes** | Reproducible inputs with lockfile. All hosts share one `flake.nix`. |
| **Home Manager** | Declarative per-user config (dotfiles, programs, GNOME dconf). Clean separation from system-level modules. |
| **Stable-first** | `nixpkgs` and `home-manager` both track 26.05 stable. GUI apps needing newer versions are installed via declarative flatpaks. |
| **Single `system.nix` entry point** | One file imports all shared system modules. Adding a module is one line — it applies fleet-wide. |
| **nix-my-gnome for dconf** | GNOME settings are generated from a live dconf dump, not hand-edited. Reproducible and version-controlled. |
| **nvf (not LazyVim)** | Declarative Neovim with native Nix LSP/treesitter packages. No runtime Mason downloads. |
| **ble.sh + `unset -f read`** | ble.sh provides vi mode and syntax highlighting, but its `read` wrapper breaks carapace/fzf completions. Removing the wrapper fixes this. |
| **All shell tools in HM** | atuin, zoxide, carapace, starship, blesh are all installed via Home Manager (not system-level) to avoid init-order conflicts with ble.sh. |

---

## Host Reference

| Host | Hardware | Special Config |
|------|----------|----------------|
| **titan** | AMD GPU, AZW SER mini-PC, LUKS encrypted root | `amdgpu` kernel module, k10temp only (no `it87` fan — EC firmware limitation), shared LUKS UUID with ghost |
| **ghost** | Intel/AMD, LUKS encrypted root | Shared LUKS UUID with titan (`8a350d7a-ce96-4ba6-938c-61b2739239f6`) |
| **minimal** | Minimal/generic | No GPU drivers, no desktop extras |
| **server** | Headless | No desktop, minimal packages |

---

## Tooling

Included in `system-level/packages.nix`:

- `nh` — NixOS helper (`nh os switch`)
- `nix-output-monitor` (`nom`) — live build TUI
- `nix-index` + `nix-locate` — find which package owns a file
- `nix-tree` — interactive dependency browser
- `nix-graph` — TUI dependency graph viewer (reverse/dependents view)
- `nix-diff` — derivation diff without building
- `nix-du` — accurate store disk usage
- `deadnix` — dead code finder
- `statix` — linter with `--fix`
- `alejandra` / `nixpkgs-fmt` — formatters
- `comma` — run packages without installing: `, cowsay hello`

---

## How To

### Add a New Host

1. Generate hardware config on the new machine:
   ```bash
   nixos-generate-config --root /mnt
   ```

2. Copy into the repo:
   ```bash
   mkdir -p ~/.config/nixos/hosts/newbox
   cp /mnt/etc/nixos/hardware-configuration.nix ~/.config/nixos/hosts/newbox/
   ```

3. Create `hosts/newbox/default.nix`:
   ```nix
   { config, lib, pkgs, inputs, ... }: {
     imports = [
       ./hardware-configuration.nix
       ../../system.nix
     ];

     networking.hostName = "newbox";
     system.stateVersion = "26.05";
   }
   ```

4. Add to `flake.nix`:
   ```nix
   hostNames = [ "ghost" "titan" "minimal" "server" "newbox" ];
   ```

5. Build to verify:
   ```bash
   nixos-rebuild build --flake .#newbox
   ```

### Add a System-Level Module

1. Create `system-level/mymodule.nix`:
   ```nix
   { config, lib, pkgs, ... }: {
     # your module content
   }
   ```

2. Import it in `system.nix`:
   ```nix
   imports = [
     # ... existing imports ...
     ./system-level/mymodule.nix
   ];
   ```

3. Verify all hosts:
   ```bash
   cd ~/.config/nixos
   nix flake check
   ```

### Add or Remove Packages

Edit `system-level/packages.nix` and add/remove from
`environment.systemPackages`.

Build, then switch:

```bash
nixos-rebuild build --flake .#titan
sudo nixos-rebuild switch --flake .#titan
```

### Add a GNOME Extension

Edit `system-level/desktop.nix`:

```nix
environment.systemPackages = with pkgs.gnomeExtensions; [
  appindicator
  blur-my-shell
  # ...
];
```

---

## License

MIT — do what you want, but don't blame me if you brick your LUKS partition.
