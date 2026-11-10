# Vim configuration — managed by Home Manager
{...}: {
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;
  };
}
