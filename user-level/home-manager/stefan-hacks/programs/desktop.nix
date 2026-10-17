# Desktop plumbing: XDG defaults and user dirs.
# Ported from ~/.config/mimeapps.list and ~/.config/user-dirs.dirs.
# GTK: ~/.config/gtk-3.0 and gtk-4.0 contain no settings.ini on this machine —
# GNOME theming is already fully covered by dconf in gnome.nix, so no gtk.*
# module is used. GNOME Shell extensions: none installed -> no programs.gnome-shell.
{ config, ... }:

let
  firefoxHandlers = {
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
  };
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = firefoxHandlers;
    associations.added = firefoxHandlers;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    # Standard dirs match the generated defaults; only the extra one is set.
    # NOTE: keys are BARE names — `PROJECTS` renders as XDG_PROJECTS_DIR.
    extraConfig = {
      PROJECTS = "${config.home.homeDirectory}/Projects";
    };
  };
}
