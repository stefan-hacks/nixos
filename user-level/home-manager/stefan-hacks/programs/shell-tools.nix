# Terminal stack: history, prompt, navigation, completions, dev-shell glue.
# These replace the manual `eval "$(... init bash)"` lines from the old .bashrc.
{ pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    # Merged from the old system-level /etc/atuin/config.toml (programs.atuin
    # in system-level/programs.nix was removed) and ~/.config/atuin/config.toml.
    settings = {
      auto_sync = true;
      sync_address = "https://atuin.sh";
      update_check = false;
      enter_accept = true;
      sync.records = true;
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    # No starship.toml existed — defaults until you write programs.starship.settings.
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    # CARAPACE_BRIDGES env var lives in programs/bash.nix sessionVariables.
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    # Replaces: alias fzf='fzf --preview "bat --color=always {}"'
    defaultOptions = [
      "--preview"
      "bat --color=always {}"
    ];
  };

  programs.bat = {
    enable = true;
    config.theme = "Coldark-Dark";
    extraPackages = with pkgs; [ bat-extras.core ]; # batman, batgrep, ...
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true; # makes `tldr --update` in the update alias redundant (kept anyway)
  };

  programs.nh = {
    enable = true;
    flake = "/home/stefan-hacks/.config/nixos";
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true; # shell wrapper `y` with cwd-on-exit
  };

  programs.zellij = {
    enable = true;
    # No bash integration — you drive it manually (zellij aliases live in bash.nix if added).
  };
}
