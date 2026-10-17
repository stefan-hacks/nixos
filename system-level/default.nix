{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./boot.nix
    ./documentation.nix
    ./environment.nix
    ./fail2ban.nix
    ./firewall.nix
    ./home-manager.nix
    ./locale.nix
    ./logging.nix
    ./maintenance.nix
    ./networking.nix
    ./pkgs-terminal.nix
    ./programs.nix
    ./services.nix
    ./user.nix
    ./virtualization.nix
  ];
  # Desktop-only modules (fonts, kanata, bluetooth, pkgs-gui, ollama) are
  # imported per-host in hosts/ghost and hosts/titan — keeping `minimal` and
  # `server` lean. hermes.nix intentionally NOT imported anywhere: WIP
  # (empty environmentFiles).
}
