# Home Manager entry point for stefan-hacks
{config, ...}: {
  imports = [
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/starship.nix
    ./programs/atuin.nix
    ./programs/helix.nix
    ./programs/zellij.nix
    ./programs/fastfetch.nix
    ./programs/lazyvim.nix
    ./gnome
  ];

  home.username = "stefan-hacks";
  home.homeDirectory = "/home/stefan-hacks";

  # ── ble.sh (Bash Line Editor) configuration ──
  # The official blesh package is enabled system-wide via programs.bash.blesh.enable
  # in system.nix. User-specific settings are configured here in ~/.blerc.
  home.file.".blerc".text = ''
    # ============================================================================
    # ble.sh user configuration — ~/.blerc
    # ============================================================================

    # ── History ──
    bleopt history_share=1
    bleopt history_limit_length=100000
    bleopt history_preserve_point=1

    # ── Prompt ──
    bleopt prompt_ps1_final='\[$(tput setaf 6)\]\w \[$(tput sgr0)\]\$ '
    bleopt prompt_command_changes_layout=1

    # ── Completion (all supported features enabled) ──
    bleopt complete_auto_complete=1
    bleopt complete_menu_complete=1
    bleopt complete_ambiguous=1
    bleopt complete_timeout_auto=5000
    bleopt complete_timeout_compvar=200

    # ── Syntax highlighting ──
    bleopt highlight_syntax=1
    bleopt highlight_filename=1
    bleopt highlight_variable=1
    bleopt highlight_eval_word_limit=200

    # ── Edit markers ──
    bleopt edit_marker=':'
    bleopt edit_marker_error=':'

    # ── Command execution markers ──
    bleopt exec_elapsed_enabled=1
    bleopt exec_errexit_mark=''$'\e[91m[exit %d]\e[m'
    bleopt exec_exit_mark=''$'\e[90m[exit %d]\e[m'

    # ── Terminal keyboard protocol ──
    bleopt term_modifyOtherKeys_external=1
    bleopt term_modifyOtherKeys_internal=1

    # ── Vi/Vim mode (NORMAL mode indicator + vim-surround) ──
    function blerc/vim-mode-hook {
      # NORMAL mode indicator in bold
      bleopt keymap_vi_mode_string_nmap=''$'\e[1m-- NORMAL --\e[m'
      bleopt keymap_vi_mode_string_imap='''
      bleopt keymap_vi_mode_string_omap=''$'\e[1m-- OPERATOR --\e[m'
      bleopt keymap_vi_mode_string_cmap='''
      bleopt keymap_vi_mode_string_rmap=''$'\e[1m-- REPLACE --\e[m'

      # Enable vim-surround contrib module
      ble-import vim-surround
    }
    blehook/eval-after-load keymap_vi blerc/vim-mode-hook

    # ── Additional keybindings ──
    # C-x C-e to open $EDITOR for current command line
    ble-bind -m emacs -f 'C-x C-e' edit-and-execute-command
    ble-bind -m vi_nmap -f 'C-x C-e' edit-and-execute-command
  '';

  # Ensure ~/.local/bin is on PATH
  home.sessionPath = [
    "''${config.home.homeDirectory}/.local/bin"
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ── Nixdatifier ──
  programs.nixdatifier = {
    enable = true;
    ui = true;
    autostart = true;
    tui = {
      commands = [
        {
          label = "rebuild";
          cmd = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#titan";
        }
        {
          label = "check";
          cmd = "cd ~/.config/nixos && nix flake check";
        }
        {
          label = "update";
          cmd = "cd ~/.config/nixos && nix flake update";
        }
        {
          label = "gc";
          cmd = "sudo nix-collect-garbage --delete-older-than 30d";
        }
      ];
      updateCheck = {
        enable = true;
        interval = "6h";
      };
      theme = "deep";
      layout = "roomy";
    };
    githubUseGh = true;
  };

  home.stateVersion = "26.05";
}
