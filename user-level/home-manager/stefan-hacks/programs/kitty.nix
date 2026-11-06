# kitty.nix — Home Manager kitty terminal configuration
# Includes kitty-scrollback.nvim integration and GNOME Adwaita dark theme.
_: let
  # GNOME Adwaita dark theme
  darkTheme = ''
    # vim:ft=kitty
    ## name:     Adwaita Dark
    ## author:   GNOME Project
    ## upstream: https://gnome.pages.gitlab.gnome.org/libadwaita/

    foreground              #FFFFFF
    background              #1E1E1E
    selection_foreground    #FFFFFF
    selection_background    #303030

    cursor                  #FFFFFF
    cursor_text_color       #1E1E1E

    url_color               #3584E4

    active_border_color     #3584E4
    inactive_border_color   #3D3846
    bell_border_color       #F6D32D

    wayland_titlebar_color system
    macos_titlebar_color system

    active_tab_foreground   #1E1E1E
    active_tab_background   #3584E4
    inactive_tab_foreground #FFFFFF
    inactive_tab_background #303030
    tab_bar_background      #1E1E1E

    mark1_foreground #1E1E1E
    mark1_background #3584E4
    mark2_foreground #1E1E1E
    mark2_background #E01B24
    mark3_foreground #1E1E1E
    mark3_background #F6D32D

    color0  #1E1E1E
    color8  #3D3846
    color1  #E01B24
    color9  #ED333B
    color2  #33D17A
    color10 #57E389
    color3  #F6D32D
    color11 #F8E45C
    color4  #3584E4
    color12 #62A0EA
    color5  #C061CB
    color13 #DC8ADD
    color6  #5E5C64
    color14 #77767B
    color7  #FFFFFF
    color15 #F6F5F4
  '';

  # GNOME Adwaita light theme
  lightTheme = ''
    # vim:ft=kitty
    ## name:     Adwaita Light
    ## author:   GNOME Project
    ## upstream: https://gnome.pages.gitlab.gnome.org/libadwaita/

    foreground              #1E1E1E
    background              #FAFAFA
    selection_foreground      #1E1E1E
    selection_background      #DEDDEA

    cursor                  #1E1E1E
    cursor_text_color       #FAFAFA

    url_color               #1C71D8

    active_border_color     #3584E4
    inactive_border_color   #C0BFBC
    bell_border_color       #F6D32D

    wayland_titlebar_color system
    macos_titlebar_color system

    active_tab_foreground   #FAFAFA
    active_tab_background   #3584E4
    inactive_tab_foreground #1E1E1E
    inactive_tab_background #DEDDEA
    tab_bar_background      #F6F5F4

    mark1_foreground #FAFAFA
    mark1_background #3584E4
    mark2_foreground #FAFAFA
    mark2_background #E01B24
    mark3_foreground #FAFAFA
    mark3_background #F6D32D

    color0  #1E1E1E
    color8  #5E5C64
    color1  #E01B24
    color9  #C01C28
    color2  #33D17A
    color10 #26A269
    color3  #F6D32D
    color11 #E5A50A
    color4  #3584E4
    color12 #1A5FB4
    color5  #C061CB
    color13 #9141AC
    color6  #5E5C64
    color14 #3D3846
    color7  #FFFFFF
    color15 #F6F5F4
  '';

  # kitty-scrollback.nvim Python kitten
  kittyScrollbackNvimPy = builtins.readFile ./kitty_scrollback_nvim.py;
in {
  programs.kitty = {
    enable = true;

    # Core settings that HM manages natively
    settings = {
      # ── Shell integration ──
      # DISABLED: ble.sh + kitty keyboard protocol conflict on exit.
      # When enabled, kitty injects progressive-enhancement escape sequences
      # (e.g. \e[>1u) that clash with ble.sh's teardown/restoration logic,
      # causing kitty to hang on shell exit with garbage like:
      #   ffd^[[100;5u^[[100;5u
      # shell_integration = "enabled";
      shell_integration = "disabled";
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
      active_border_color = "#3584E4";
      inactive_border_color = "#3D3846";

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

    # Extra Kitty config (verbatim) — themes + key mappings + kittens
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
