# kitty.nix — Home Manager kitty terminal configuration
# Includes kitty-scrollback.nvim integration and Catppuccin themes.
_: let
  # Catppuccin-Mocha theme (dark)
  darkTheme = ''
    # vim:ft=kitty
    ## name:     Catppuccin-Mocha
    ## author:   Pocco81 (https://github.com/Pocco81)
    ## license:  MIT
    ## upstream: https://github.com/catppuccin/kitty/blob/main/themes/mocha.conf
    ## blurb:    Soothing pastel theme for the high-spirited!

    foreground              #CDD6F4
    background              #1E1E2E
    selection_foreground    #1E1E2E
    selection_background    #F5E0DC

    cursor                  #F5E0DC
    cursor_text_color       #1E1E2E

    url_color               #F5E0DC

    active_border_color     #B4BEFE
    inactive_border_color   #6C7086
    bell_border_color       #F9E2AF

    wayland_titlebar_color system
    macos_titlebar_color system

    active_tab_foreground   #11111B
    active_tab_background   #CBA6F7
    inactive_tab_foreground #CDD6F4
    inactive_tab_background #181825
    tab_bar_background      #11111B

    mark1_foreground #1E1E2E
    mark1_background #B4BEFE
    mark2_foreground #1E1E2E
    mark2_background #CBA6F7
    mark3_foreground #1E1E2E
    mark3_background #74C7EC

    color0  #45475A
    color8  #585B70
    color1  #F38BA8
    color9  #F38BA8
    color2  #A6E3A1
    color10 #A6E3A1
    color3  #F9E2AF
    color11 #F9E2AF
    color4  #89B4FA
    color12 #89B4FA
    color5  #F5C2E7
    color13 #F5C2E7
    color6  #94E2D5
    color14 #94E2D5
    color7  #BAC2DE
    color15 #A6ADC8
  '';

  # Catppuccin-Latte theme (light)
  lightTheme = ''
    # vim:ft=kitty
    ## name:     Catppuccin-Latte
    ## author:   Pocco81 (https://github.com/Pocco81)
    ## license:  MIT
    ## upstream: https://github.com/catppuccin/kitty/blob/main/themes/latte.conf

    foreground              #4C4F69
    background              #EFF1F5
    selection_foreground    #EFF1F5
    selection_background    #DC8A78

    cursor                  #DC8A78
    cursor_text_color       #EFF1F5

    url_color               #DC8A78

    active_border_color     #7287FD
    inactive_border_color   #9CA0B0
    bell_border_color       #DF8E1D

    wayland_titlebar_color system
    macos_titlebar_color system

    active_tab_foreground   #EFF1F5
    active_tab_background   #8839EF
    inactive_tab_foreground #4C4F69
    inactive_tab_background #9CA0B0
    tab_bar_background      #BCC0CC

    mark1_foreground #EFF1F5
    mark1_background #7287fD
    mark2_foreground #EFF1F5
    mark2_background #8839EF
    mark3_foreground #EFF1F5
    mark3_background #209FB5

    color0  #5C5F77
    color8  #6C6F85
    color1  #D20F39
    color9  #D20F39
    color2  #40A02B
    color10 #40A02B
    color3  #DF8E1D
    color11 #DF8E1D
    color4  #1E66F5
    color12 #1E66F5
    color5  #8839EF
    color13 #8839EF
    color6  #179299
    color14 #179299
    color7  #ACB0Be
    color15 #BCC0CC
  '';

  # kitty-scrollback.nvim Python kitten
  kittyScrollbackNvimPy = builtins.readFile ./kitty_scrollback_nvim.py;
in {
  programs.kitty = {
    enable = true;

    # Core settings that HM manages natively
    settings = {
      # ── Shell integration ──
      shell_integration = "enabled";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";

      # ── Performance ──
      repaint_delay = "10";
      input_delay = "3";
      sync_to_monitor = "yes";

      # ── Cursor ──
      cursor_trail = "3";
      cursor_trail_decay = "0.1 0.4";

      # ── Window appearance ──
      window_border_width = "1pt";
      draw_minimal_borders = "yes";
      hide_window_decorations = "yes";
      active_border_color = "#00ff00";
      inactive_border_color = "#282828";

      # ── Window sizing ──
      remember_window_size = "no";
      initial_window_width = "800";
      initial_window_height = "500";
      startup_mode = "windowed";
      window_margin_width = "5";
      single_window_margin_width = "0";
      window_padding_width = "2";
      inactive_text_alpha = "0.7";

      # ── Layouts ──
      enabled_layouts = "splits,stack,tall,fat,grid,horizontal,vertical";

      # ── Transparency ──
      background_opacity = "0.95";
      dim_opacity = "0.90";
      background_blur = "1";

      # ── Fonts ──
      font_family = "JetBrainsMono Nerd Font Mono Thin";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "13.0";
      disable_ligatures = "never";

      # ── URL handling ──
      url_style = "curly";
      open_url_with = "default";
      url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
      detect_urls = "yes";
      allow_hyperlinks = "yes";

      # ── Tab bar ──
      tab_bar_edge = "top";
      tab_bar_margin_width = "1.0";
      tab_bar_margin_height = "1.0 0.5";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_title_template = "\"{index}: {title}\"";
      active_tab_title_template = "\"[{index}: {title}]\"";
      tab_fade = "0.25 0.5 0.75 1";
      active_tab_font_style = "bold-italic";
      inactive_tab_font_style = "normal";

      # ── Bell ──
      enable_audio_bell = "no";
    };

    extraConfig = ''
      # ═══════════════════════════════════════════════════════════════════════════
      # THEME
      # ═══════════════════════════════════════════════════════════════════════════
      include dark-theme.auto.conf

      # ═══════════════════════════════════════════════════════════════════════════
      # KEYBINDINGS
      # ═══════════════════════════════════════════════════════════════════════════

      # Font size
      map ctrl+equal  change_font_size all +2.0
      map ctrl+minus  change_font_size all -2.0
      map ctrl+0       change_font_size all 0

      # URL hints
      map ctrl+shift+u open_url_with_hints

      # Tab navigation
      map alt+1 goto_tab 1
      map alt+2 goto_tab 2
      map alt+3 goto_tab 3
      map alt+4 goto_tab 4
      map alt+5 goto_tab 5
      map alt+6 goto_tab 6
      map alt+7 goto_tab 7
      map alt+8 goto_tab 8
      map alt+9 goto_tab 9
      map alt+0 goto_tab 10

      map ctrl+tab        next_tab
      map ctrl+shift+tab previous_tab

      map ctrl+t new_tab
      map ctrl+shift+w close_tab

      map ctrl+shift+page_up   move_tab_backward
      map ctrl+shift+page_down move_tab_forward

      map ctrl+shift+n        new_tab_with_cwd
      map ctrl+shift+enter    new_window_with_cwd

      # Window / pane management
      map alt+- launch --cwd=current --location=hsplit
      map alt+\ launch --cwd=current --location=vsplit

      map alt+h neighboring_window left
      map alt+l neighboring_window right
      map alt+k neighboring_window up
      map alt+j neighboring_window down

      map alt+shift+k resize_window taller
      map alt+shift+j resize_window shorter 3
      map alt+shift+h resize_window wider
      map alt+shift+l resize_window narrower

      map shift+ctrl+alt+k move_window up
      map shift+ctrl+alt+h move_window left
      map shift+ctrl+alt+l move_window right
      map shift+ctrl+alt+j move_window down

      map ctrl+shift+q  close_window
      map ctrl+shift+x  detach_window

      map ctrl+shift+down  neighboring_window down
      map ctrl+shift+up    neighboring_window up
      map ctrl+shift+left  neighboring_window left
      map ctrl+shift+right neighboring_window right

      map f11                    toggle_fullscreen
      map ctrl+shift+f           next_layout
      map ctrl+shift+d           previous_layout

      map ctrl+shift+alt+t goto_layout tall
      map ctrl+shift+alt+s goto_layout stack
      map ctrl+shift+alt+f goto_layout fat
      map ctrl+shift+alt+g goto_layout grid
      map ctrl+shift+alt+h goto_layout horizontal
      map ctrl+shift+alt+v goto_layout vertical
      map ctrl+shift+alt+p goto_layout splits

      map ctrl+shift+r start_resizing_window

      map ctrl+shift+alt+down  resize_window taller 10
      map ctrl+shift+alt+up    resize_window shorter 10
      map ctrl+shift+alt+left  resize_window narrower 10
      map ctrl+shift+alt+right resize_window wider 10

      map ctrl+shift+e  reset_window_sizes
      map ctrl+shift+space toggle_layout stack
      map ctrl+alt+space   layout_action rotate
      map ctrl+alt+shift+space layout_action mirror toggle
      map ctrl+alt+m layout_action mirror true

      # Stack layout
      map ctrl+shift+equal focus_visible_window
      map ctrl+shift+minus nth_window -1

      # OS window management
      map ctrl+shift+alt+n new_os_window
      map ctrl+shift+alt+] next_os_window
      map ctrl+shift+alt+[ previous_os_window
      map ctrl+shift+alt+w close_os_window

      # Window focus by index
      map ctrl+1 first_window
      map ctrl+2 second_window
      map ctrl+3 third_window
      map ctrl+4 fourth_window
      map ctrl+5 fifth_window
      map ctrl+6 sixth_window
      map ctrl+7 seventh_window
      map ctrl+8 eighth_window
      map ctrl+9 ninth_window
      map ctrl+0 tenth_window

      # Broadcast
      map ctrl+shift+b kitten broadcast

      # ═══════════════════════════════════════════════════════════════════════════
      # KITTY-SCROLLBACK.NVIM INTEGRATION
      # ═══════════════════════════════════════════════════════════════════════════
      action_alias kitty_scrollback_nvim kitten ~/.config/kitty/kitty_scrollback_nvim.py

      map ctrl+shift+h kitty_scrollback_nvim
      map ctrl+shift+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output

      mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output

      # ═══════════════════════════════════════════════════════════════════════════
      # CONFIG RELOAD / DEBUG
      # ═══════════════════════════════════════════════════════════════════════════
      map ctrl+alt+r               load_config_file
      map ctrl+shift+alt+comma     edit_config_file
      map ctrl+shift+alt+d       debug_config

      # ═══════════════════════════════════════════════════════════════════════════
      # MOUSE
      # ═══════════════════════════════════════════════════════════════════════════
      mouse_map left click ungrabbed mouse_click_url_or_select
      mouse_map left doublepress ungrabbed mouse_selection word
      mouse_map left triplepress ungrabbed mouse_selection line
      mouse_map middle press ungrabbed paste_from_selection

      mouse_map left click grabbed mouse_handle_click release
      mouse_map left press grabbed mouse_handle_click

      mouse_map ctrl+shift+left press grabbed discard_event
      mouse_map ctrl+shift+left drag grabbed mouse_move_window

      # ═══════════════════════════════════════════════════════════════════════════
      # CLIPBOARD
      # ═══════════════════════════════════════════════════════════════════════════
      map ctrl+shift+c copy_to_clipboard
      map ctrl+shift+v paste_from_clipboard
      map shift+insert paste_from_clipboard

      map ctrl+shift+alt+c copy_to_buffer a
      map ctrl+shift+alt+v paste_from_buffer a

      # ═══════════════════════════════════════════════════════════════════════════
      # SCROLLING
      # ═══════════════════════════════════════════════════════════════════════════
      map ctrl+shift+page_up   scroll_line_up
      map ctrl+shift+page_down scroll_line_down
      map ctrl+shift+home      scroll_home
      map ctrl+shift+end       scroll_end

      map ctrl+alt+home  scroll_to_prompt -1
      map ctrl+alt+end   scroll_to_prompt 1

      # ═══════════════════════════════════════════════════════════════════════════
      # MISC
      # ═══════════════════════════════════════════════════════════════════════════
      map ctrl+shift+escape kitty_shell window
      map ctrl+shift+alt+i kitten unicode_input
      map ctrl+shift+o open_selected_path
      map ctrl+shift+backspace send_signal SIGINT
    '';
  };

  # Place theme files and kitten in ~/.config/kitty/
  xdg.configFile."kitty/dark-theme.auto.conf".text = darkTheme;
  xdg.configFile."kitty/light-theme.auto.conf".text = lightTheme;
  xdg.configFile."kitty/no-preference-theme.auto.conf".text = lightTheme;
  xdg.configFile."kitty/kitty_scrollback_nvim.py".text = kittyScrollbackNvimPy;
}
