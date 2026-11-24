# Declarative GNOME color calibration (ICC profiles).
# Colord automatically picks up profiles in ~/.local/share/icc/
# when their EDID hash matches the connected monitor.
# These profiles are ghost-specific but harmless on other hosts
# (unused if the monitor is not connected).
#
# NOTE: Using home.activation to *copy* files instead of home.file
# symlinks because colord tries to overwrite generated profiles,
# and writing through a symlink fails with "Too many levels of
# symbolic links".
{
  config,
  lib,
  ...
}: {
  home.activation.copyIccProfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.local/share/icc
    $DRY_RUN_CMD cp -f ${../../../../assets/icc/ghost/edid-a6f8f533d7d106c2a2c48e4d69fe4b8a.icc} \
      ${config.home.homeDirectory}/.local/share/icc/edid-a6f8f533d7d106c2a2c48e4d69fe4b8a.icc
    $DRY_RUN_CMD cp -f ${../../../../assets/icc/ghost/edid-546c8347313e78a1add6a73b801d488a.icc} \
      ${config.home.homeDirectory}/.local/share/icc/edid-546c8347313e78a1add6a73b801d488a.icc
  '';
}
