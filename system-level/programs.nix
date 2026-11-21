# System-wide program configuration
{pkgs, ...}: {
  programs = {
    # programs.firefox.enable = true;
    gpaste.enable = true;

    # fzf — enable bash fuzzy completion and keybindings
    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };

    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Use lxqt-openssh-askpass instead of the default x11-ssh-askpass.
    # The default X11 askpass triggers a GNOME/Wayland "Allow inhibiting shortcuts"
    # portal dialog on every invocation because it has no .desktop file registered.
    ssh = {
      enableAskPassword = true;
      askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    };
  };
}
