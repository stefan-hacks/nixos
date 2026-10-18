# System-wide program configuration
{ config, lib, pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.gpaste.enable = true;
  programs.starship.enable = true;

  # Configure the Atuin Shell Client System-Wide
  programs.atuin = {
    enable = true;

    # Declarative client parameters written automatically to /etc/atuin/config.toml
    settings = {
      auto_sync = true;
      sync_address = "https://atuin.sh"; # Change to https://api.atuin.sh if using the default public sync server
      update_check = false;
    };
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
