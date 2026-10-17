{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.bash = {
    enable = true;
    completion.enable = true;
  };

  programs.git.enable = true;

  # OpenSSH agent disabled - using GNOME's gcr-ssh-agent instead

  programs.gnupg.agent = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.firefox.enable = true;

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

  programs.virt-manager = {
    enable = true;
  };

  programs.command-not-found.enable = true;
}
