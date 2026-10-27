# system.nix — Main entry point for the NixOS fleet.
# Imports all system-level modules.
# Hosts import this file plus their hardware-configuration.nix and home-manager user config.
{...}: {
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
    ./system-level/theming.nix
    ./system-level/flatpak.nix
    ./system-level/libvirt-vms.nix
  ];

  # System-level user account (Home Manager handles dotfiles and user config)
  users.users."stefan-hacks" = {
    isNormalUser = true;
    description = "stefan-hacks";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "dialout"
    ];
    # Password is managed imperatively or via agenix/sops
  };
}
