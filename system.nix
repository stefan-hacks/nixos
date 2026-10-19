# system.nix — Main entry point for the NixOS fleet.
# Imports all system-level and user-level modules.
# Hosts import this file plus their hardware-configuration.nix.
{ config, lib, pkgs, ... }:

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

    # User-level modules (user accounts, dotfiles, per-user system config)
    ./user-level/users.nix
    ./user-level/dotfiles.nix
  ];
}
