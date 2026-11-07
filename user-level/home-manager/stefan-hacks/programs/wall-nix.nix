# wall-nix declarative GNOME/GDM theming from wallpaper
# All options exposed so you can tweak visually and find what you like.
{...}: {
  programs.wall-nix = {
    enable = true;
    wallpaper = ../../../../assets/wallpapers/nixos_wallpapers/23970564.png;
    colors = 5;
    variant = "dark";
    kittyTheme = true;
    autoSwitch = true;

    # ── Top Bar / Panel ──
    bar = {
      height = 36.0;          # px
      margin = 6.5;           # px around panel
      borderRadius = 12.0;    # 0 = rectangle, 999 = pill
      borderWidth = 0;        # px border thickness
      alpha = 0.85;           # panel opacity 0.0–1.0
      # background = null;    # explicit #RRGGBB override
      # foreground = null;    # explicit #RRGGBB override
      # accent = null;        # explicit #RRGGBB override
      style = "fixed";        # fixed | floating | islands
    };

    # ── Menus / Popovers (Calendar, Quick Settings, etc) ──
    menu = {
      # background = null;    # explicit #RRGGBB override
      # foreground = null;    # explicit #RRGGBB override
      # borderColor = null;   # explicit #RRGGBB override
      borderRadius = 12.0;    # px
      # alpha = null;         # 0.0–1.0 opacity override
      shadow = true;          # drop shadow on menus
    };

    # ── GTK 3/4 & Flatpak ──
    gtk = {
      headerbarAccent = true;
      sidebarAccent = true;
      cardAccent = true;
      trafficLights = false;  # macOS-style window controls
      windowBorder = true;
      popoverRadius = 12.0;     # px
      buttonRadius = 999.0;     # 999 = pill buttons
      entryRadius = 999.0;      # 999 = pill entries
    };
  };
}
