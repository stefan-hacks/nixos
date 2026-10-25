# System-wide program configuration
{
  ...
}: {
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

  # fzf — enable bash fuzzy completion and keybindings
  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # fzf — set default options globally so all fzf invocations get the preview.
  # Quoted preview command ensures --color=always is passed to bat, not parsed
  # as an fzf --color option (which would fail with "invalid color specification").
  environment.sessionVariables.FZF_DEFAULT_OPTS = "--preview 'bat --color=always {}'";
}
