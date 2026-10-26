# System-level declarative flatpak management via nix-flatpak.
# All GUI desktop apps listed here are installed system-wide so every user
# can launch them.  Corresponding nixpkgs packages should be REMOVED from
# system-level/packages.nix to avoid duplication.
{inputs, ...}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  # Enable the flatpak subsystem (required by nix-flatpak)
  services.flatpak.enable = true;

  # ── Remotes ──
  # Flathub is added by default; declare it explicitly so we can add extras later.
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
  ];

  # ── Packages ──
  # Each string is a flathub app ID.  Add/remove as desired.
  services.flatpak.packages = [
    # ── Browsers ──
    "org.mozilla.firefox"
    "org.chromium.Chromium"

    # ── Productivity / Office ──
    "net.cozic.joplin_desktop"
    "org.libreoffice.LibreOffice"
    "org.onlyoffice.desktopeditors"

    # ── Communication ──
    "com.discordapp.Discord"
    "im.riot.Riot"
    "com.ktechpit.whatsie"

    # ── Media ──
    "org.videolan.VLC"
    "io.mpv.Mpv"
    "de.haeckerfelix.Shortwave"
    "org.jellyfin.JellyfinDesktop"
    "org.nickvision.tubeconverter" # Parabolic
    "org.soundconverter.SoundConverter"
    "com.rafaelmardojai.Blanket"
    "com.github.wwmm.easyeffects"

    # ── Utilities ──
    "org.qbittorrent.qBittorrent"
    "org.localsend.localsend_app"
    "io.gitlab.adhami3310.Impression"
    "net.nokyan.Resources"

    # ── Email / PIM ──
    "org.gnome.Evolution"

    # ── Security ──
    "com.onepassword.OnePassword"

    # ── User-requested additions ──
    "io.github.diegopvlk.Cine"
    "net.donnybeelo.Convey"
  ];

  # ── Auto-updates ──
  # Update flatpaks automatically on a weekly cadence.  This is the main
  # reason to use flatpaks: versions newer than nixos-26.05 stable.
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };

  # Also update on first activation (e.g. after nixos-rebuild switch)
  services.flatpak.update.onActivation = true;
}
