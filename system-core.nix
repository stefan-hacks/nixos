# system-core.nix — Core modules shared by ALL hosts (desktop and headless).
_: {
  imports = [
    ./system-level/boot.nix
    ./system-level/nix-settings.nix
    ./system-level/networking.nix
    ./system-level/locale.nix
    ./system-level/firewall.nix
    ./system-level/fail2ban.nix
    ./system-level/logging.nix
    ./system-level/maintenance.nix
    ./system-level/programs.nix
    ./system-level/packages.nix
    ./system-level/hardening.nix
    ./system-level/grc.nix
    ./system-level/color-output.nix
  ];

  # Base user account (Home Manager manages dotfiles)
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
  };
}
