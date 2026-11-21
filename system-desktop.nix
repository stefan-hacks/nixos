# system-desktop.nix — Desktop-only modules (GNOME, audio, GUI apps, etc.)
# Import this alongside system-core.nix for hosts that run a graphical desktop.
_: {
  imports = [
    ./system-level/bluetooth.nix
    ./system-level/desktop.nix
    ./system-level/audio.nix
    ./system-level/avatar.nix
    ./system-level/kanata.nix
    ./system-level/virtualization.nix
    ./system-level/printing.nix
    ./system-level/theming.nix
    ./system-level/flatpak.nix
    ./system-level/nvf.nix
  ];
}