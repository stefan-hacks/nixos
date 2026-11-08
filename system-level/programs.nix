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
}
