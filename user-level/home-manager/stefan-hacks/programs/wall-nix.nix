# wall-nix declarative GNOME/GDM theming from wallpaper
# ═════════════════════════════════════════════════════════════════════════════
# FULLY-LOADED CONFIGURATION — every option exposed with sensible defaults.
#
# The wall-nix tool auto-matches your wallpaper to a kitty-themes palette.
# If the match looks bad (it happens), uncomment and tweak the color overrides
# below. The defaults here are tuned for a dark, cohesive look.
#
# TIP: Set `variant = "auto"` to let the tool detect light vs dark from your
#      wallpaper, or force `"dark"` / `"light"` explicitly.
# ═════════════════════════════════════════════════════════════════════════════
{...}: {
  programs.wall-nix = {
    enable = true;
    wallpaper = ../../../../assets/wallpapers/nixos_wallpapers/23970564.png;
    colors = 5;            # more colors = richer palette extraction
    variant = "dark";      # dark | light | auto
    kittyTheme = true;
    autoSwitch = true;     # reload dconf on activation

    # ─────────────────────────────────────────────────────────────────────────
    # TOP BAR / PANEL
    # ─────────────────────────────────────────────────────────────────────────
    # "floating" style with pill radius looks best.  If you prefer the stock
    # solid panel, change style to "fixed" and reduce borderRadius.
    bar = {
      height = 38.0;          # panel height in px
      margin = 8.0;           # margin around the floating panel
      borderRadius = 999.0;   # 999 = full pill, 0 = rectangle, 12 = slight rounding
      borderWidth = 0;        # border thickness (0 = no border)
      alpha = 0.80;           # panel background opacity (0.0 = invisible, 1.0 = solid)

      # Color overrides — leave commented to use the auto-matched palette.
      # Uncomment and tweak if the matched colors look bad.
      # background = "#1e1e2e";   # dark base (catppuccin mocha)
      # foreground = "#cdd6f4";   # light text
      # accent     = "#89b4fa";   # blue accent

      style = "floating";     # fixed | floating | islands
    };

    # ─────────────────────────────────────────────────────────────────────────
    # MENUS / POPOVERS
    # ─────────────────────────────────────────────────────────────────────────
    # Calendar, Quick Settings, right-click menus, etc.
    # These should be slightly lighter than the panel for depth.
    menu = {
      # Color overrides — leave commented for auto-match.
      # background = "#313244";    # surface0 (good contrast on dark desktop)
      # foreground = "#cdd6f4";    # light text
      # borderColor = "#45475a";   # subtle border

      borderRadius = 16.0;      # px rounding of menu corners
      # alpha = 0.95;            # menu opacity (uncomment to override)
      shadow = true;            # drop shadow behind menus
    };

    # ─────────────────────────────────────────────────────────────────────────
    # GTK 3/4 & FLATPAK APPS
    # ─────────────────────────────────────────────────────────────────────────
    # Controls native apps: Nautilus, Settings, Firefox menus, etc.
    gtk = {
      headerbarAccent = true;   # tint headerbar with accent color
      sidebarAccent = true;     # tint sidebar selections with accent
      cardAccent = true;        # tint cards / dialogs with accent
      trafficLights = false;    # macOS-style close/min/max buttons (off by default)
      windowBorder = true;      # subtle colored window border

      # Radius controls — lower = more square, higher = more rounded
      popoverRadius = 14.0;     # context menus, dropdowns
      buttonRadius = 10.0;      # buttons (10 = slightly rounded, 999 = pill)
      entryRadius = 8.0;        # search boxes, text inputs
    };
  };
}
