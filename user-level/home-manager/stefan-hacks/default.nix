# Home Manager entry point for stefan-hacks
{config, ...}: {
  imports = [
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/atuin.nix
    ./programs/carapace.nix
    ./programs/starship.nix
    ./programs/helix.nix
    ./programs/zellij.nix
    ./programs/fastfetch.nix
    ./programs/bat.nix
    ./gnome
  ];

  # Enable wall-nix declarative GNOME theming
  programs.wall-nix = {
    enable = true;
    wallpaper = ../../../assets/wallpapers/nixos_wallpapers/nix-wallpaper-nineish-catppuccin-frappe.png;
    gdmBackground = ../../../assets/wallpapers/nixos_wallpapers/nix-wallpaper-waterfall.png;
    colors = 5;
    autoSwitch = true;
  };

  # User environment
  home = {
    username = "stefan-hacks";
    homeDirectory = "/home/stefan-hacks";
    stateVersion = "26.05";

    # Ensure ~/.local/bin is on PATH.
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
  };

  # Let Home Manager manage its own configuration.
  # btop configuration with Catppuccin-Mocha theme
  xdg.configFile."btop/btop.conf".text = ''
    # btop configuration — managed by Nix
    color_theme = "catppuccin-mocha"
    theme_background = True
    truecolor = True
    force_tty = False
    vim_keys = True
    rounded_corners = True
    graph_symbol = "braille"
    graph_symbol_cpu = "default"
    graph_symbol_mem = "default"
    graph_symbol_net = "default"
    graph_symbol_proc = "default"
    shown_boxes = "cpu mem net proc"
    update_ms = 1000
    proc_sorting = "cpu lazy"
    proc_reversed = False
    proc_tree = False
    proc_colors = True
    proc_gradient = True
    proc_per_core = False
    cpu_graph_upper = "total"
    cpu_graph_lower = "total"
    cpu_invert_lower = True
    cpu_single_graph = False
    cpu_bottom = False
    show_uptime = True
    check_temp = True
    cpu_sensor = "Auto"
    show_coretemp = True
    coretemp_pack = False
    show_cpu_freq = True
    show_graphs = True
    mem_graphs = True
    mem_below_net = False
    show_swap = True
    swap_disk = True
    show_disks = True
    only_physical = True
    use_fstab = False
    disk_free_priv = False
    show_battery = True
    show_powersave = True
    selected_battery = "Auto"
    show_iface = True
    alternate_ouput = True
    proc_editor = "nvim"
  '';

  # btop Catppuccin-Mocha theme
  xdg.configFile."btop/themes/catppuccin-mocha.theme".text = ''
    #Bashtop theme with Catppuccin-Mocha palette (https://github.com/catppuccin/catppuccin)
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="#1E1E2E"
    # Main text color
    theme[main_fg]="#CDD6F4"
    # Title color for boxes
    theme[title]="#CBA6F7"
    # Highlight color for keyboard shortcuts
    theme[hi_fg]="#89B4FA"
    # Background color of selected item in processes box
    theme[selected_bg]="#313244"
    # Foreground color of selected item in processes box
    theme[selected_fg]="#CDD6F4"
    # Color of inactive/disabled text
    theme[inactive_fg]="#6C7086"
    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="#CDD6F4"
    # Background color of the percentage meters
    theme[meter_bg]="#45475A"
    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#89B4FA"
    # Cpu box outline color
    theme[cpu_box]="#89B4FA"
    # Memory box outline color
    theme[mem_box]="#A6E3A1"
    # Net box outline color
    theme[net_box]="#F5C2E7"
    # Proc box outline color
    theme[proc_box]="#F9E2AF"
    # Box divider line and small arrows color
    theme[div_line]="#45475A"
    # Temperature graph colors
    theme[temp_start]="#A6E3A1"
    theme[temp_mid]="#F9E2AF"
    theme[temp_end]="#F38BA8"
    # CPU graph colors
    theme[cpu_start]="#89B4FA"
    theme[cpu_mid]="#CBA6F7"
    theme[cpu_end]="#F38BA8"
    # Mem/Memory graph colors
    theme[mem_start]="#A6E3A1"
    theme[mem_mid]="#F9E2AF"
    theme[mem_end]="#F38BA8"
    # Net graph colors
    theme[net_start]="#A6E3A1"
    theme[net_mid]="#F9E2AF"
    theme[net_end]="#F38BA8"
    # Proc box color gradient for processes
    theme[proc_start]="#89B4FA"
    theme[proc_mid]="#CBA6F7"
    theme[proc_end]="#F38BA8"
  '';

  programs.home-manager.enable = true;

  # Nixdatifier
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
}
