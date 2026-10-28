# Zellij terminal multiplexer — Home Manager module
# Config lives in ./zellij-config.kdl and is symlinked to ~/.config/zellij/config.kdl
_: {
  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij-config.kdl;
}
