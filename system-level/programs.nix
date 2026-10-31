# System-wide program configuration
_: {
  # programs.firefox.enable = true;
  programs.gpaste.enable = true;

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
  environment.sessionVariables = {
    FZF_DEFAULT_OPTS = "--preview 'bat --color=always {}'";
    FLAKE = "/home/stefan-hacks/.config/nixos";
  };
}
