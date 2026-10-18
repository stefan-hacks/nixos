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

  # fzf — fix invalid color specification from old home-manager config.
  # The preview command must be quoted so --color=always is passed to bat,
  # not interpreted as an fzf --color option.
  environment.sessionVariables.FZF_DEFAULT_OPTS = "--preview 'bat --color=always {}'";
}
