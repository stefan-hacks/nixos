# System-wide program configuration
_: {
  # programs.firefox.enable = true;
  programs.gpaste.enable = true;

  # programs.atuin — DISABLED at system level because it injects
  # `eval "$(atuin init bash)"` into /etc/bashrc, which runs BEFORE ~/.bashrc
  # and therefore BEFORE ble.sh attaches.  Atuin then falls back to raw
  # readline escape-sequence bindings that ble.sh intercepts as literal text
  # (the "A5" garbage).  Atuin is initialised at user-level in bash.nix
  # AFTER ble-attach so it detects BLE_ATTACHED and uses ble.sh widgets.
  #
  # Keep the sync settings in user-level atuin.nix instead.
  # programs.atuin = {
  #   enable = true;
  #   settings = { ... };
  # };

  # Zoxide — package available system-wide, but bash integration is handled
  # at user-level in bash.nix so we can control init order (after ble.sh
  # source, before ble-attach).
  programs.zoxide = {
    enable = true;
    enableBashIntegration = false; # DISABLED — handled in user bash.nix
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
