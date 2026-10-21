# system.nix — Main entry point for the NixOS fleet.
# Imports all system-level and user-level modules.
# Hosts import this file plus their hardware-configuration.nix.
{ config, lib, pkgs, ... }:

let
  # ═══════════════════════════════════════════════════════════════════════════
  # SINGLE SOURCE OF TRUTH: PRIMARY USER
  # ═══════════════════════════════════════════════════════════════════════════
  # Change this ONE value to switch all user-level config (dotfiles, GNOME,
  # services) to a different user. The system will automatically read from
  # user-level/${primaryUser}/ for that user's configs.
  #
  # To add a new user:
  #   1. Create user-level/<username>/
  #   2. Add <username>.nix and dotfiles/ inside it
  #   3. Change this value and rebuild
  # ═══════════════════════════════════════════════════════════════════════════
  primaryUser = "stefan-hacks";
in
{
  imports = [
    # System-level modules (shared OS configuration)
    ./system-level/boot.nix
    ./system-level/nix-settings.nix
    ./system-level/bluetooth.nix
    ./system-level/desktop.nix
    ./system-level/networking.nix
    ./system-level/audio.nix
    ./system-level/locale.nix
    ./system-level/firewall.nix
    ./system-level/fail2ban.nix
    ./system-level/logging.nix
    ./system-level/maintenance.nix
    ./system-level/programs.nix
    ./system-level/services.nix
    ./system-level/virtualization.nix
    ./system-level/packages.nix
    ./system-level/nvf.nix
    ./system-level/hermes.nix
    ./system-level/theming.nix

    # User-level module: pass the primary user name so all per-user config
    # auto-wires to the correct directory and service permissions.
    (import ./user-level/user-module.nix { username = primaryUser; })
  ];
}
