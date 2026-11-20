# System-wide program configuration
{ pkgs, ... }: {
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

  # Use lxqt-openssh-askpass instead of the default x11-ssh-askpass.
  # The default X11 askpass triggers a GNOME/Wayland "Allow inhibiting shortcuts"
  # portal dialog on every invocation because it has no .desktop file registered.
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };
}
