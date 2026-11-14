# ⌨️ Kanata + GNOME — Full Keyboard-Driven Workflow

> Declarative keyboard remapping with Kanata. Four layers, home-row modifiers, and native GNOME window-management integration — no mouse required.

---

## What is Kanata?

[Kanata](https://github.com/jtroo/kanata) is a cross-platform keyboard remapping tool that runs as a system service. It intercepts key events at a low level and allows you to define **tap-hold** keys, **layers**, and **macros** in a simple Lisp-like configuration.

In this NixOS config, Kanata is managed declaratively via `services.kanata` in `system-level/kanata.nix`. The service starts at boot and applies the remapping to all keyboards.

**Key concepts:**

| Concept | What it means |
|---------|--------------|
| **Tap-hold** | A key sends its normal character when tapped, but acts as a modifier (Ctrl, Alt, Super) when held |
| **Layer** | A virtual keymap activated while a modifier is held. Release the modifier and you're back to the base layer |
| **Alias** | A named shortcut for a complex key sequence or tap-hold definition |

**Timing:** `tap-time 200ms`, `hold-time 200ms` — quick taps register as normal keys; holds longer than 200ms activate the modifier/layer.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│  BASE LAYER (Layer 1) — Everyday typing                     │
│  ├─ Home row = tap-hold modifiers (S=Super, D=Alt, F=Ctrl)  │
│  ├─ Thumb keys = layer triggers (Space=L2, Win=L3, Ctrl=L4) │
│  ├─ F-row = media & system controls (hold to activate)      │
│  └─ Number row = shifted symbols on hold                    │
│                                                             │
│  LAYER 2 — Symbols (hold Space)                             │
│  └─ Full symbol layer: !@#$%^&*()_+ {}[]|\                 │
│                                                             │
│  LAYER 3 — Windows & Workspaces (hold Left Meta/S key)      │
│  └─ Spatial positioning, workspace nav, window snapping     │
│                                                             │
│  LAYER 4 — Text Editing (hold Left Ctrl)                    │
│  └─ Mouse wheel emulation, arrow keys, word deletion        │
└─────────────────────────────────────────────────────────────┘
```

---

## Layer 1 — Base Layer (Daily Typing)

This is your normal QWERTY layout, but with **dual-function keys** on the home row and thumb cluster.

### Home Row Tap-Hold Modifiers

The home row keys act as normal letters when tapped, but as modifiers when held:

| Key | Tap | Hold (modifier) |
|-----|-----|-----------------|
| **S** | `s` | **Left Super** (Windows key) |
| **D** | `d` | **Left Alt** |
| **F** | `f` | **Left Ctrl** |
| **H** | `h` | **Shift+\u0060** (GNOME Activities overview) |
| **J** | `j` | **Right Ctrl** |
| **K** | `k` | **Right Alt** |
| **L** | `l` | **Right Super** |

**How to use:** Type normally — the keys register as letters. Need to press `Super+T` to open a terminal? Hold **S** and tap **T**.

> ⚠️ **Timing matters:** If you hold S for longer than 200ms before pressing T, it registers as `Super+T`. If you tap and release quickly, it's just `s`.

### Thumb Cluster

| Key | Tap | Hold |
|-----|-----|------|
| **Backspace** | Backspace | Delete |
| **Enter** | Enter | Right Alt |
| **Space** | Space | **Layer 2** (Symbols) |
| **Left Meta (S key)** | Left Super | **Layer 3** (Windows/Workspaces) |
| **Left Ctrl** | Left Ctrl | **Layer 4** (Editing) |

### Number Row — Shifted Symbols on Hold

Hold any number key to get its shifted symbol:

| Key | Tap | Hold |
|-----|-----|------|
| ` | `` ` `` | **~** |
| 1 | `1` | **!** |
| 2 | `2` | **@** |
| 3 | `3` | **#** |
| 4 | `4` | **$** |
| 5 | `5` | **%** |
| 6 | `6` | **^** |
| 7 | `7` | **&** |
| 8 | `8` | **\*** |
| 9 | `9` | **(** |
| 0 | `0` | **)** |
| - | `-` | **\_** |
| = | `=` | **+** |

### Top Row — Ctrl+Shortcuts on Hold

| Key | Tap | Hold |
|-----|-----|------|
| **Q** | `q` | **Ctrl+Q** (quit app) |
| **W** | `w` | **Ctrl+W** (close tab) |
| **E** | `e` | **Ctrl+E** |
| **R** | `r` | **Ctrl+R** (reload) |
| **T** | `t` | **Ctrl+T** (new tab) |

### Navigation Row (Y, U, I, O)

| Key | Tap | Hold |
|-----|-----|------|
| **Y** | `y` | **Home** |
| **U** | `u` | **Page Down** |
| **I** | `i` | **Page Up** |
| **O** | `o` | **End** |

### Media Controls (P, [, ], ;, ')

| Key | Tap | Hold |
|-----|-----|------|
| **P** | `p` | **Play/Pause** |
| **[** | `[` | **Previous Track** |
| **]** | `]` | **Next Track** |
| **;** | `;` | **Scroll Left** |
| **'** | `'` | **Scroll Right** |

### Bottom Row — Cut/Copy/Paste on Hold

| Key | Tap | Hold |
|-----|-----|------|
| **Z** | `z` | **Ctrl+Z** (undo) |
| **X** | `x` | **Ctrl+X** (cut) |
| **C** | `c` | **Ctrl+C** (copy) |
| **V** | `v` | **Ctrl+V** (paste) |

### F-Row System Controls

Hold any F-key to activate its secondary function:

| Key | Tap | Hold |
|-----|-----|------|
| **F1** | F1 | Quake terminal dropdown |
| **F2** | F2 | Run command (Alt+F2) |
| **F3** | F3 | Decrease brightness |
| **F4** | F4 | Increase brightness |
| **F5** | F5 | Toggle mute |
| **F6** | F6 | Volume down |
| **F7** | F7 | Volume up |
| **F8** | F8 | Toggle microphone |
| **F9** | F9 | Screenshot |
| **F10** | F10 | Lock screen |

---

## Layer 2 — Symbols (Hold Space)

Activated by **holding Space**. Release Space to return to Layer 1.

```
┌──────────────────────────────────────────────┐
│  caps  F1   F2   F3   F4   F5   F6   F7... │  (F-row unchanged)
├──────────────────────────────────────────────┤
│  ~     !    @    #    $    %    ^    &    *  (    )    _    +   bspc
│  tab   !    @    #    $    %    0    (    )    {    }    [    ]    \
│  esc   ^    &    *    /    `    ~    \    :    "    ...            ret
│        -    +    _    =    \    <    >    ,    .    ?
└──────────────────────────────────────────────┘
```

This layer gives you full access to programming symbols without reaching for Shift. Hold Space and type:
- **Hash comments:** Hold Space + 3 → `#`
- **Dollar variables:** Hold Space + 4 → `$`
- **Curly braces:** Hold Space + [ or ] → `{` or `}`
- **Pipe:** Hold Space + \ → `|`

---

## Layer 3 — Windows & Workspaces (Hold Left Meta / S key)

This is the **GNOME integration layer**. Hold the **Left Meta key** (bound to S via `@ss`) to activate this layer. It's designed to make GNOME feel like a tiling window manager.

### Spatial Window Positioning — Left-Hand 3×3 Grid

The left-hand Q/W/E, A/S/D, Z/X/C keys form a spatial positioning pad:

```
         Q          W          E
      ┌────────┬──────────┬────────┐
      │  NW    │   Top    │  NE    │
      │ corner │   edge   │ corner │
      ├────────┼──────────┼────────┤
   A  │  Left  │  Center  │ Right  │  D
      │  edge  │          │  edge  │
      ├────────┼──────────┼────────┤
      │  SW    │  Bottom  │  SE    │
      │ corner │   edge   │ corner │
      └────────┴──────────┴────────┘
         Z          X          C
```

**Modifiers sent:** `Super+Ctrl+...` — these map to GNOME's native window-positioning actions configured in `gnome/window-manager.nix`.

| Key | Action | GNOME Shortcut |
|-----|--------|----------------|
| **Q** | Move to top-left corner | Super+Ctrl+Shift+Left |
| **W** | Move to top edge | Super+Ctrl+Up |
| **E** | Move to top-right corner | Super+Ctrl+Shift+Right |
| **A** | Move to left edge | Super+Ctrl+Left |
| **S** | Center window | Super+Ctrl+C |
| **D** | Move to right edge | Super+Ctrl+Right |
| **Z** | Move to bottom-left corner | Super+Ctrl+Shift+Down |
| **X** | Move to bottom edge | Super+Ctrl+Down |
| **C** | Move to bottom-right corner | Super+Ctrl+Shift+Up |

**Example workflow:**
1. Open two terminals
2. Hold S (Left Meta), press **A** → first terminal snaps to left half
3. Hold S, press **D** → second terminal snaps to right half
4. Hold S, press **Q** → first terminal moves to top-left quadrant
5. Hold S, press **C** → second terminal moves to bottom-right quadrant

### Window Snapping — Right-Hand Keys (H, J, K, L)

| Key | Action | GNOME Shortcut |
|-----|--------|----------------|
| **H** | Snap to left | Super+Left |
| **J** | Restore/unmaximize | Super+Down |
| **K** | Maximize | Super+Up |
| **L** | Snap to right | Super+Right |

These are the classic half-screen snaps, accessible while holding the layer.

### Workspace Navigation — Y, [, ], O

| Key | Action | GNOME Shortcut |
|-----|--------|----------------|
| **Y** | Switch to first workspace | Super+Home |
| **[** | Switch to previous workspace | Super+PageUp |
| **]** | Switch to next workspace | Super+PageDown |
| **O** | Switch to last workspace | Super+End |

### Move Windows Between Workspaces/Monitors — N, M, ,, .

| Key | Action | GNOME Shortcut |
|-----|--------|----------------|
| **N** | Move window to monitor left | Shift+Super+Left |
| **M** | Move window to workspace left | Shift+Super+PageUp |
| **,** | Move window to workspace right | Shift+Super+PageDown |
| **.** | Move window to monitor right | Shift+Super+Right |

### Media Controls (Still Active)

**P**, **;**, **'** remain active for play/pause and scrolling even in Layer 3.

### Special: F12 = Reload Kanata Config

While in Layer 3, tapping **F12** sends `lrld` — Kanata's live-reload command. Useful when iterating on this config.

---

## Layer 4 — Text Editing (Hold Left Ctrl)

Activated by **holding Left Ctrl**. This layer transforms the right side of the keyboard into text-editing tools.

### Mouse Wheel Emulation (H, J, K, L)

| Key | Action |
|-----|--------|
| **H** | Mouse wheel left |
| **J** | Mouse wheel down |
| **K** | Mouse wheel up |
| **L** | Mouse wheel right |

### Arrow Keys (Replaces H/J/K/L on home row)

In Layer 4, the actual **arrow keys** are available on the home row right side — for terminals and editors that don't support mouse wheel.

### Word Deletion (M, ,, .)

| Key | Action |
|-----|--------|
| **M** | Delete word backward (Ctrl+Backspace) |
| **,** | Delete word forward (Alt+Delete) |
| **.** | Delete to beginning of line (Ctrl+U) |
| **[** | Delete to end of line (Ctrl+K) |

---

## Quick Reference Card

### Layer Activation

| Hold Key | Layer | Purpose |
|----------|-------|---------|
| **Space** | Layer 2 | Symbols |
| **S key (Left Meta)** | Layer 3 | Windows & Workspaces |
| **Left Ctrl** | Layer 4 | Text Editing |

### Most-Used Combos

| Action | How |
|--------|-----|
| **Snap window left** | Hold S, tap H |
| **Snap window right** | Hold S, tap L |
| **Maximize** | Hold S, tap K |
| **Center window** | Hold S, tap S (spatial) |
| **Next workspace** | Hold S, tap ] |
| **Prev workspace** | Hold S, tap [ |
| **Move window to next workspace** | Hold S, tap , |
| **New terminal** | Hold S, tap T |
| **Close tab** | Hold F, tap W |
| **Play/Pause** | Tap P (hold) |
| **Volume up** | Hold F7 |
| **Screenshot** | Hold F9 |
| **Type `#`** | Hold Space, tap 3 |
| **Type `{`** | Hold Space, tap [ |

---

## NixOS Integration

The Kanata config is entirely declarative:

- **`system-level/kanata.nix`** — The Kanata service and KDL configuration
- **`user-level/home-manager/stefan-hacks/gnome/window-manager.nix`** — GNOME keybindings for spatial positioning
- **`system-level/desktop.nix`** — GNOME extensions (blur-my-shell, steal-my-focus, etc.)

All changes require a rebuild:

```bash
cd ~/.config/nixos
sudo nixos-rebuild switch --flake .#titan
```

The Kanata service auto-restarts on rebuild. No manual `systemctl` needed.

---

## Tips

1. **Start slow.** Learn Layer 1 tap-holds first (S=Super, F=Ctrl). Add Layer 3 spatial positioning after a few days.
2. **Timing is configurable.** If 200ms feels too fast or slow, edit `tap-time` and `hold-time` in `kanata.nix`.
3. **Layer 3 is modal.** You're either in the workspace layer (holding S) or you're not. This is intentional — it prevents accidental window moves during normal typing.
4. **The scroll keys (; and ') work everywhere** — in browsers, terminals, file managers. No mouse needed.
5. **F-row media controls are hold-only.** Tap F5 for F5; hold F5 for mute. Muscle memory develops quickly.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Kanata not starting | `systemctl status kanata-kanata.service` |
| Keys feel "sticky" | Increase `hold-time` in `kanata.nix` |
| Spatial positioning doesn't work | Verify GNOME keybindings with `gsettings list-recursively org.gnome.desktop.wm.keybindings` |
| Want to reload config without rebuild | Hold S, tap F12 (Layer 3) |

---

*Configuration: `system-level/kanata.nix`*  
*GNOME bindings: `user-level/home-manager/stefan-hacks/gnome/window-manager.nix`*  
*Generated: `system-level/kanata.nix` + `gnome/window-manager.nix` in harmony*
