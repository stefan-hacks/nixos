# foot.nix — Home Manager foot terminal
{
  ...
}: {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        shell = "/bin/bash";
        term = "foot";
        login-shell = "yes";
        font = "JetBrainsMono Nerd Font:size=11:fontfeatures=calt:fontfeatures=liga";
        font-bold = "JetBrainsMono Nerd Font:style=Bold:size=11";
        font-italic = "JetBrainsMono Nerd Font:style=Italic:size=11";
        font-bold-italic = "JetBrainsMono Nerd Font:style=Bold Italic:size=11";
        box-drawings-uses-font-glyphs = "no";
        dpi-aware = "yes";
        initial-window-size-chars = "105x28";
        pad = "12x12";
        resize-delay-ms = "20";
      };

      scrollback = {
        lines = "50000";
        multiplier = "3.0";
      };

      cursor = {
        style = "block";
        blink = "yes";
        underline-thickness = "1.5px";
      };

      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };

      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjkl;eowcmgh";
        osc8-underline = "always";
      };

      colors = {
        foreground = "cdd6f4";
        background = "1e1e2e";
        regular0 = "45475a";
        regular1 = "f38ba8";
        regular2 = "a6e3a1";
        regular3 = "f9e2af";
        regular4 = "89b4fa";
        regular5 = "f5c2e7";
        regular6 = "94e2d5";
        regular7 = "bac2de";
        bright0 = "585b70";
        bright1 = "f38ba8";
        bright2 = "a6e3a1";
        bright3 = "f9e2af";
        bright4 = "89b4fa";
        bright5 = "f5c2e7";
        bright6 = "94e2d5";
        bright7 = "a6adc8";
        selection-foreground = "cdd6f4";
        selection-background = "313244";
        urls = "89b4fa";
        flash = "585b70";
        flash-alpha = "0.5";
      };

      cursor-color = {
        color = "11111b f5e0dc";
      };

      key-bindings = {
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        scrollback-up-half-page = "Control+Shift+u";
        scrollback-down-half-page = "Control+Shift+d";
        font-increase = "Control+plus Control+equal";
        font-decrease = "Control+minus";
        font-reset = "Control+0";
        url-launch = "Control+Shift+o";
        clipboard-copy = "Control+Shift+c XF86Copy";
        clipboard-paste = "Control+Shift+v XF86Paste";
        search-start = "Control+Shift+f";
      };

      search-bindings = {
        cancel = "Escape Control+g";
        find-prev = "Control+p";
        find-next = "Control+n";
      };
    };
  };
}
