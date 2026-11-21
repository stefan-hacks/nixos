# Declarative GNOME color calibration (ICC profiles).
# Colord automatically picks up profiles in ~/.local/share/icc/
# when their EDID hash matches the connected monitor.
# These profiles are ghost-specific but harmless on other hosts
# (unused if the monitor is not connected).
_: {
  home.file = {
    ".local/share/icc/edid-a6f8f533d7d106c2a2c48e4d69fe4b8a.icc".source =
      ../../../../assets/icc/ghost/edid-a6f8f533d7d106c2a2c48e4d69fe4b8a.icc;

    ".local/share/icc/edid-546c8347313e78a1add6a73b801d488a.icc".source =
      ../../../../assets/icc/ghost/edid-546c8347313e78a1add6a73b801d488a.icc;
  };
}