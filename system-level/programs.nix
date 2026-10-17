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

  # User-facing program configuration lives at user-level (home-manager):
  #   atuin / starship / zoxide / carapace / direnv  -> programs/shell-tools.nix
  #   gpg + gpg-agent/SSH agent                       -> programs/security.nix
  #   (this also resolves the old gnupg.agent-vs-gcr-ssh-agent contradiction)

  programs.firefox.enable = true; # stefan-hacks' default daily browser (mime defaults at user-level/desktop.nix)

  programs.virt-manager = {
    enable = true;
  };

  programs.command-not-found.enable = true;
}
