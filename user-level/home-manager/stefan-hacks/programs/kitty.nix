# Kitty terminal — full port of ~/.config/kitty/kitty.conf (~250 lines).
# Rendering order in HM: extraConfig < themeFile include < shell_integration
# < settings < actionAliases < keybindings < mouseBindings.
# active/inactive border colors are intentionally NOT in settings: the old
# conf set them before `include current-theme.conf`, so Catppuccin Mocha's
# values (#B4BEFE / #6C7086) were the effective ones — which HM now reproduces
# by letting the theme own them.
{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    themeFile = "Catppuccin-Mocha";

    # Original conf: `shell_integration enabled` (full). Set via the module
    # option — putting `shell_integration` in settings is silently overridden.
    # (HM implies "no-rc", which is correct alongside a HM-managed bashrc.)
    shellIntegration.mode = "enabled";

    font = {
      name = "JetBrainsMono Nerd Font Mono Thin";
      size = 13;
    };

    settings = {
      # Remote control (kitty-scrollback.nvim dependency)
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty-\${USER}";

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # Cursor
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";

      # Window appearance (border colors owned by the theme — see header note)
      window_border_width = "1pt";
      draw_minimal_borders = true;
      hide_window_decorations = false;

      # Window sizing & behaviour
      remember_window_size = false;
      initial_window_width = 800;
      initial_window_height = 500;
      startup_mode = "windowed";
      window_margin_width = 5;
      single_window_margin_width = 0;
      window_padding_width = 2;
      inactive_text_alpha = "0.7";

      # Tiling layouts
      enabled_layouts = "splits,stack,tall,fat,grid,horizontal,vertical";

      # Transparency
      background_opacity = "0.95";
      dim_opacity = "0.90";
      background_blur = 1;

      # Fonts
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      disable_ligatures = "never";

      # URL handling
      url_style = "curly";
      open_url_with = "default";
      url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
      detect_urls = true;
      allow_hyperlinks = true;

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_margin_width = "1.0";
      tab_bar_margin_height = "1.0 0.5";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_title_template = ''"{index}: {title}"'';
      active_tab_title_template = ''"[{index}: {title}]"'';
      tab_fade = "0.25 0.5 0.75 1";
      active_tab_font_style = "bold-italic";
      inactive_tab_font_style = "normal";

      # Bell
      enable_audio_bell = false;
    };

    actionAliases = {
      # kitty_scrollback_nvim.py is provided by the kitty-scrollback.nvim Neovim
      # plugin — wire it via nixvim (programs/nixvim.nix) when you add it.
      kitty_scrollback_nvim = "kitten ~/.config/kitty/kitty_scrollback_nvim.py";
    };

    keybindings = {
      # Font size
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";

      # URL hints
      "ctrl+shift+u" = "open_url_with_hints";

      # Tab navigation
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
      "alt+7" = "goto_tab 7";
      "alt+8" = "goto_tab 8";
      "alt+9" = "goto_tab 9";
      "alt+0" = "goto_tab 10";
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
      "ctrl+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+page_up" = "move_tab_backward";
      "ctrl+shift+page_down" = "move_tab_forward";
      "ctrl+shift+n" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";

      # Window / pane management
      "alt+-" = "launch --cwd=current --location=hsplit";
      "alt+\\" = "launch --cwd=current --location=vsplit";
      "alt+h" = "neighboring_window left";
      "alt+l" = "neighboring_window right";
      "alt+k" = "neighboring_window up";
      "alt+j" = "neighboring_window down";
      "alt+shift+k" = "resize_window taller";
      "alt+shift+j" = "resize_window shorter 3";
      "alt+shift+h" = "resize_window wider";
      "alt+shift+l" = "resize_window narrower";
      "shift+ctrl+alt+k" = "move_window up";
      "shift+ctrl+alt+h" = "move_window left";
      "shift+ctrl+alt+l" = "move_window right";
      "shift+ctrl+alt+j" = "move_window down";
      "ctrl+shift+q" = "close_window";
      "ctrl+shift+x" = "detach_window";
      "ctrl+shift+down" = "neighboring_window down";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "f11" = "toggle_fullscreen";
      "ctrl+shift+f" = "next_layout";
      "ctrl+shift+d" = "previous_layout";
      "ctrl+shift+alt+t" = "goto_layout tall";
      "ctrl+shift+alt+s" = "goto_layout stack";
      "ctrl+shift+alt+f" = "goto_layout fat";
      "ctrl+shift+alt+g" = "goto_layout grid";
      "ctrl+shift+alt+h" = "goto_layout horizontal";
      # "ctrl+shift+alt+v" (goto_layout vertical) from the original conf is dead:
      # kitty keeps the LAST bind, and clipboard's paste_from_buffer a wins below.
      "ctrl+shift+alt+p" = "goto_layout splits";
      "ctrl+shift+r" = "start_resizing_window";
      "ctrl+shift+alt+down" = "resize_window taller 10";
      "ctrl+shift+alt+up" = "resize_window shorter 10";
      "ctrl+shift+alt+left" = "resize_window narrower 10";
      "ctrl+shift+alt+right" = "resize_window wider 10";
      "ctrl+shift+e" = "reset_window_sizes";
      "ctrl+shift+space" = "toggle_layout stack";
      "ctrl+alt+space" = "layout_action rotate";
      "ctrl+alt+shift+space" = "layout_action mirror toggle";
      "ctrl+alt+m" = "layout_action mirror true";

      # Stack layout
      "ctrl+shift+equal" = "focus_visible_window";
      "ctrl+shift+minus" = "nth_window -1";

      # OS window management
      "ctrl+shift+alt+n" = "new_os_window";
      "ctrl+shift+alt+]" = "next_os_window";
      "ctrl+shift+alt+[" = "previous_os_window";
      "ctrl+shift+alt+w" = "close_os_window";

      # Window focus by index
      "ctrl+1" = "first_window";
      "ctrl+2" = "second_window";
      "ctrl+3" = "third_window";
      "ctrl+4" = "fourth_window";
      "ctrl+5" = "fifth_window";
      "ctrl+6" = "sixth_window";
      "ctrl+7" = "seventh_window";
      "ctrl+8" = "eighth_window";
      "ctrl+9" = "ninth_window";
      # "ctrl+0" already bound: font-size reset (kept from your conf)

      # Broadcast
      "ctrl+shift+b" = "kitten broadcast";

      # kitty-scrollback.nvim
      "ctrl+shift+h" = "kitty_scrollback_nvim";
      "ctrl+shift+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";

      # Config reload / debug
      "ctrl+alt+r" = "load_config_file";
      "ctrl+shift+alt+comma" = "edit_config_file";
      "ctrl+shift+alt+d" = "debug_config";

      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "shift+insert" = "paste_from_clipboard";
      "ctrl+shift+alt+c" = "copy_to_buffer a";
      "ctrl+shift+alt+v" = "paste_from_buffer a";

      # Scrolling
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      "ctrl+alt+home" = "scroll_to_prompt -1";
      "ctrl+alt+end" = "scroll_to_prompt 1";
      # NOTE: ctrl+shift+page_up/down were double-bound (move_tab_* above,
      # scroll_line_* in the original file) — kitty keeps the LAST binding, so
      # tab-moving won there too; scroll uses home/end + ctrl+alt variants.

      # Misc
      "ctrl+shift+escape" = "kitty_shell window";
      "ctrl+shift+alt+i" = "kitten unicode_input"; # avoids ble.sh C-S-u collision
      "ctrl+shift+o" = "open_selected_path";
      "ctrl+shift+backspace" = "send_signal SIGINT";
    };

    mouseBindings = {
      # kitty-scrollback.nvim: select command output
      "ctrl+shift+right press ungrabbed" =
        "combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";

      "left click ungrabbed" = "mouse_click_url_or_select";
      "left doublepress ungrabbed" = "mouse_selection word";
      "left triplepress ungrabbed" = "mouse_selection line";
      "middle press ungrabbed" = "paste_from_selection";
      "left click grabbed" = "mouse_handle_click release";
      "left press grabbed" = "mouse_handle_click";
      "ctrl+shift+left press grabbed" = "discard_event";
      "ctrl+shift+left drag grabbed" = "mouse_move_window";
    };
  };
}
