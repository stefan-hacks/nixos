{ config, pkgs, lib, ... }:

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
}
