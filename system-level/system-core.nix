# system-core.nix — Core modules shared by ALL hosts (desktop and headless).
_: {
  imports = [
    ./boot.nix
    ./nix-settings.nix
    ./networking.nix
    ./locale.nix
    ./firewall.nix
    ./fail2ban.nix
    ./logging.nix
    ./maintenance.nix
    ./programs.nix
    ./packages.nix
    ./hardening.nix
    ./grc.nix
    ./color-output.nix
    ./fwupd.nix
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
