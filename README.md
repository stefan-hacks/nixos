# ❄️ NixOS Fleet Configuration

> Flake-based NixOS with Home Manager. Multi-host, multi-layer modular system
> for **titan**, **ghost**, **minimal**, and **server** — managed entirely
> through Nix expressions.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│  flake.nix                                                          │
│  ├── inputs: nixpkgs (26.05), home-manager (release-26.05),        │
│  │          disko, nvf, hermes-agent, nixdatifier, nix-graph,       │
│  │          vellum, kitty-scrollback
│  └── outputs: nixosConfigurations.{titan,ghost,minimal,server}       │
│                                                                     │
│  HOST (hosts/<host>/default.nix)                                    │
│  ├── hardware-configuration.nix                                   │
│  ├── disko-config.nix  (initial install only)                     │
│  └── imports → system.nix                                           │
│                                                                     │
│  SYSTEM (system.nix)                                                │
│  ├── system-level/  ──→  boot, desktop, audio, networking,        │
│  │                         packages, nvf (maximal), security,      │
│  │                         maintenance, theming, virtualization       │
│  └── users.users.stefan-hacks                                       │
│                                                                     │
│  USER (home-manager)                                                │
│  └── user-level/home-manager/stefan-hacks/                          │
│      ├── programs/  ──→  bash (ble.sh + 289 aliases), kitty,       │
│      │                     starship, atuin, helix, zellij,         │
│      │                     foot, fastfetch, git                     │
│      └── gnome/     ──→  15 dconf modules (nix-my-gnome generated)  │
└─────────────────────────────────────────────────────────────────────┘
```

**Design principle:** `system.nix` is the shared OS entry point. Home Manager
handles all per-user dotfiles and program configuration. Host files are thin
wrappers.

---

## Quickstart

### Rebuild a specific host

```bash
cd ~/.config/nixos

# Build (dry-run, no activation)
nixos-rebuild build --flake .#titan

# Switch (activate on current machine)
sudo nixos-rebuild switch --flake .#titan
```

> **Tip:** Always `build` first, `switch` second. If the build fails, your
> running system stays untouched.

### Update and rebuild

```bash
nix flake update
sudo nixos-rebuild switch --flake .#titan
```

### Check all hosts

```bash
cd ~/.config/nixos
nix flake check
```

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
│   ├── programs.nix                # Firefox, fzf, starship, atuin, zoxide
│   ├── services.nix                # Printing, kanata
│   ├── virtualization.nix          # QEMU/KVM, virt-manager
│   ├── packages.nix                # System-wide packages (the big list)
│   ├── nvf.nix                     # nvf maximal Neovim config
│   ├── hermes.nix                  # Hermes agent packages
│   └── ollama.nix                  # Ollama (optional)
│
└── user-level/home-manager/stefan-hacks/   # HM user config
    ├── default.nix                 # HM entry point
    ├── programs/
    │   ├── bash.nix                # ble.sh, 289 aliases, vi mode
    │   ├── bash_functions.txt      # Bash functions from _bash_aliases
    │   ├── bash_init_extra.sh      # Init code (sourced by bash.nix)
    │   ├── blerc                   # ble.sh config
    │   ├── kitty.nix               # Kitty terminal + scrollback.nvim
    │   ├── kitty_scrollback_nvim.py
    │   ├── starship.nix            # Nerd Font Symbols Preset
    │   ├── atuin.nix               # Shell history sync
    │   ├── helix.nix               # evil-helix config
    │   ├── zellij.nix              # Raw KDL config
    │   ├── foot.nix                # Catppuccin-mocha terminal
    │   ├── fastfetch.nix           # JSONC config
    │   └── git.nix                 # Git user.name, user.email
    └── gnome/                      # 15 dconf modules (nix-my-gnome generated)
        ├── accessibility.nix
        ├── app-folders.nix
        ├── gtk.nix
        ├── shell.nix
        ├── shell-extensions.nix
        ├── window-manager.nix
        └── ...
```

---

## Flake Inputs

| Input              | URL                                               | Branch/Tag | Purpose                               |
| ------------------ | ------------------------------------------------- | ---------- | ------------------------------------- |
| `nixpkgs`          | `github:NixOS/nixpkgs/nixos-26.05`                | stable     | **Primary package set**               |
| `nixpkgs-unstable` | `github:NixOS/nixpkgs/nixos-unstable`             | unstable   | **Only** for `joplin-desktop` overlay |
| `home-manager`     | `github:nix-community/home-manager/release-26.05` | stable     | Per-user dotfiles + programs          |
| `disko`            | `github:nix-community/disko/master`               | master     | Declarative disk partitioning         |
| `nvf`              | `github:notashelf/nvf/main`                       | main       | Neovim configuration framework        |
| `hermes-agent`     | `github:NousResearch/hermes-agent/main`           | main       | Hermes desktop packages               |
| `nixdatifier`      | `github:Muddyblack/nixdatifier`                   | master     | NixOS desktop widget + TUI            |
| `nix-graph`        | `github:AlexAntonik/nix-graph`                    | default    | Interactive Nix dependency graph TUI  |
| `vellum`           | `github:blackhat-7/vellum.nvim`                   | —          | nvf extraPlugin (flake = false)       |
| `kitty-scrollback` | `github:mikesmithgh/kitty-scrollback.nvim/v8.0.0` | v8.0.0     | nvf extraPlugin (flake = false)       |

> **Stable-first policy:** All inputs use nixos-26.05 / release-26.05 where
> available. Unstable is only used when a package is unavailable in stable
> (currently: `joplin-desktop`).

---

## Installing from NixOS ISO (with Disko)

Disko is used **once** during initial install. After that,
`hardware-configuration.nix` contains filesystem declarations and disko imports
are commented out.

### 1. Boot the NixOS installer and identify your disk

```bash
lsblk
# Note the device name, e.g. /dev/nvme0n1
```

### 2. Edit the host's disko template

Open `hosts/<host>/disko-config.nix` and set the `device` to your real disk.

| Host        | Template                         | Layout                                                               |
| ----------- | -------------------------------- | -------------------------------------------------------------------- |
| **titan**   | `hosts/titan/disko-config.nix`   | LUKS + LVM (`cryptroot` UUID `8a350d7a-ce96-4ba6-938c-61b2739239f6`) |
| **ghost**   | `hosts/ghost/disko-config.nix`   | Same LUKS+LVM (shares cryptroot UUID with titan)                     |
| **minimal** | `hosts/minimal/disko-config.nix` | Simple ext4, no LUKS                                                 |
| **server**  | `hosts/server/disko-config.nix`  | Simple ext4, no LUKS                                                 |

### 3. Uncomment the disko imports in the host's `default.nix`

In `hosts/<host>/default.nix`, uncomment these two lines:

```nix
# inputs.disko.nixosModules.disko
# ./disko-config.nix
```

### 4. Partition, format, and mount

```bash
# From the NixOS installer, run disko via the flake:
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko -- \
  --mode destroy,format,mount ./hosts/<host>/disko-config.nix
```

> ⚠️ **This will erase the entire target disk.**

### 5. Generate hardware config

```bash
# Tell nixos-generate-config NOT to write filesystems — disko already handled them.
sudo nixos-generate-config --no-filesystems --root /mnt
```

### 6. Copy your configuration and install

```bash
# Copy your repo into the target mount
sudo mkdir -p /mnt/etc/nixos
sudo cp -r ~/.config/nixos/* /mnt/etc/nixos/

# Install NixOS
sudo nixos-install --flake /mnt/etc/nixos#<host>
```

### 7. Post-install cleanup

After rebooting, **re-comment** the disko import lines in the host's
`default.nix`. From now on, rebuild with flakes:

```bash
sudo nixos-rebuild switch --flake .#<host>
```

---

## How It Works

### Three Layers

| Layer      | File(s)                                                  | What lives here                                                               |
| ---------- | -------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **Host**   | `hosts/<host>/default.nix`, `hardware-configuration.nix` | Hardware, LUKS, GPU drivers, hostname, per-host imports                       |
| **System** | `system.nix` + `system-level/*.nix`                      | OS-wide settings: boot, desktop, audio, network, packages, services, security |
| **User**   | `user-level/home-manager/stefan-hacks/**/*.nix`          | Dotfiles, program configs, shell aliases, GNOME dconf                         |

### Home Manager Integration

Each host's `default.nix` imports `home-manager.nixosModules.home-manager` and
wires:

```nix
home-manager = {
  useGlobalPkgs = true;
  useUserPackages = true;
  sharedModules = [ inputs.nixdatifier.homeManagerModules.default ];
  users."stefan-hacks" = import ../../user-level/home-manager/stefan-hacks;
};
```

This means **all user config is declarative** — no manual `~/.bashrc` edits.
Changes are activated on rebuild via `home-manager-stefan-hacks.service`.

### Bash Aliases (289 aliases)

The `bash.nix` module sources `bash_functions.txt` and provides 289 shell
aliases covering:

- **Nix/NixOS** — `nsw`, `nbd`, `nfu`, `nfc`, `nfmt`, `ndiff`, `ngc`, `nroots`,
  `nrepair`
- **Git** — `g`, `gs`, `ga`, `gco`, `gcb`, `gl`, `gd`, `gundo`, `gitup`, `gwip`,
  `gprune`
- **Docker/Podman** — `dps`, `dex`, `dlogs`, `dc`, `dcu`, `dcd`, `pps`, `pex`
- **Kubernetes** — `k`, `kgp`, `kgn`, `kd`, `kl`, `kaf`, `kctx`, `kns`
- **Systemd** — `sctl`, `scts`, `sctr`, `jrn`, `jrnb`, `jrnf`, `sblame`
- **Networking** — `ip`, `ipa`, `ports`, `ss`, `dnsq`, `curl-time`
- **Files/Archives** — `extract`, `tar-gz`, `mkfile`, `duh`, `dud`
- **DevOps** — `tf`, `tfi`, `tfp`, `tfa`, `ap`, `api`

See `user-level/home-manager/stefan-hacks/programs/bash.nix` for the full list.

### Neovim (nvf maximal)

The `nvf.nix` module enables the **maximal bundled configuration**:

- **Autocomplete:** `blink-cmp` (rust fuzzy matcher)
- **LSP:** rust-analyzer, nixd, bashls, jsonls, yamlls, taplo, clangd, gopls,
  pylsp, lua_ls, tsserver, java-language-server, kotlin-language-server, texlab,
  dockerls, sqlls
- **Languages:** nix, bash, rust, go, python, typescript, java, kotlin, zig,
  lua, typst, tex, json, toml, yaml, xml, docker, html, css, scss, cmake, sql,
  markdown
- **Extra plugins:** vellum.nvim, kitty-scrollback.nvim
- **Git:** gitsigns, neogit
- **UI:** alpha dashboard, noice, colorizer, illuminate, fidget,
  indent-blankline
- **Motion:** hop, leap, precognition
- **Terminal:** toggleterm + lazygit

> **Note:** Building nvf maximal downloads many language servers. The first
> build may take a while. The `nvf` cachix cache is recommended.

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

### Add a New User

Create `user-level/home-manager/<username>/default.nix` following the same
structure as `stefan-hacks/`. Then add to the host's `default.nix`:

```nix
home-manager.users."<username>" = import ../../user-level/home-manager/<username>;
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
  dynamic-music-pill
  pomodoro-timer
  quick-settings-audio-panel
  quake-terminal
  vitals
];
```

---

## Host Reference

| Host        | Hardware                                      | Special Config                                                                                             |
| ----------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **titan**   | AMD GPU, AZW SER mini-PC, LUKS encrypted root | `amdgpu` kernel module, k10temp only (no `it87` fan — EC firmware limitation), shared LUKS UUID with ghost |
| **ghost**   | Intel/AMD, LUKS encrypted root                | Shared LUKS UUID with titan (`8a350d7a-ce96-4ba6-938c-61b2739239f6`)                                       |
| **minimal** | Minimal/generic                               | No GPU drivers, no desktop extras                                                                          |
| **server**  | Headless                                      | No desktop, minimal packages                                                                               |

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

## Key Design Decisions

| Decision                            | Rationale                                                                                                               |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Flakes**                          | Reproducible inputs with lockfile. All hosts share one `flake.nix`.                                                     |
| **Home Manager**                    | Declarative per-user config (dotfiles, programs, GNOME dconf). Clean separation from system-level modules.              |
| **Stable-first**                    | `nixpkgs` and `home-manager` both track 26.05 stable. `nixpkgs-unstable` is only used selectively for `joplin-desktop`. |
| **Single `system.nix` entry point** | One file imports all shared system modules. Adding a module is one line — it applies fleet-wide.                        |
| **nix-my-gnome for dconf**          | GNOME settings are generated from a live dconf dump, not hand-edited. Reproducible and version-controlled.              |
| **nvf maximal**                     | Full language support + IDE-like features (LSP, debugging, completions, git integration) out of the box.                |
| **Convention-based bash aliases**   | `Downloads/_bash_aliases` is the canonical source. Aliases are extracted and embedded into `bash.nix` automatically.    |

---

## License

MIT — do what you want, but don't blame me if you brick your LUKS partition.
