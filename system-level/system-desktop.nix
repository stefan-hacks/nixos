# system-desktop.nix — Desktop-only modules (GNOME, audio, GUI apps, etc.)
# Import this alongside system-core.nix for hosts that run a graphical desktop.
_: {
  imports = [
    ./bluetooth.nix
    ./desktop.nix
    ./audio.nix
    ./avatar.nix
    ./kanata.nix
    ./virtualization.nix
    ./printing.nix
    ./theming.nix
    ./flatpak.nix
    ./nvf.nix
  ];

  # Plymouth graphical boot splash (desktop-only).
  # Uses the default theme (spinner) showing a lock icon for LUKS unlock.
  boot.plymouth.enable = true;
}
