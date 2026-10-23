# starship.nix — Home Manager starship prompt
{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      scan_timeout = 10;
      command_timeout = 2000;
      add_newline = true;

      format = "$directory$git_branch$git_status$python$rust$nodejs$nix_shell\n[╰─](dimmed)$character ";
      right_format = "$cmd_duration$time$battery";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_visual_symbol = "[❮](bold yellow)";
      };

      username = {
        style_user = "bold green";
        style_root = "bold red";
        format = "[$user]($style)";
        disabled = false;
        show_always = true;
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname](bold dimmed green) ";
        disabled = false;
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold cyan";
        read_only = " 🔒";
        read_only_style = "bold red";
      };

      git_branch = {
        symbol = "\ue0a0 ";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold yellow";
        conflicted = "🏳";
        ahead = "🏎💨";
        behind = "😰";
        diverged = "😵";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "➕";
        renamed = "👅";
        deleted = "🗑";
      };

      python = {
        symbol = "🐍 ";
        format = "[$symbol$pyenv_prefix($version )(\($virtualenv\))]($style)";
        style = "bold yellow";
      };

      rust = {
        symbol = "🦀 ";
        format = "[$symbol($version )]($style)";
        style = "bold red";
      };

      nodejs = {
        symbol = "⬢ ";
        format = "[$symbol($version )]($style)";
        style = "bold green";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "[$symbol$state( \\($name\\))]($style) ";
        style = "bold blue";
      };

      time = {
        disabled = false;
        format = "[🕙 $time]($style) ";
        style = "bold dimmed white";
        time_format = "%H:%M";
      };

      cmd_duration = {
        min_time = 500;
        format = "[ took $duration]($style) ";
        style = "bold yellow";
      };

      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "💀";
        display = [
          { threshold = 10; style = "bold red"; }
          { threshold = 30; style = "bold yellow"; }
          { threshold = 100; style = "bold green"; }
        ];
      };

      status = {
        style = "bg:blue";
        symbol = "🔴 ";
        success_symbol = "🟢 ";
        format = "[\\[$symbol$common_meaning$signal_name$maybe_int\\]]($style) ";
        map_symbol = true;
        disabled = false;
      };

      sudo = {
        style = "bold red";
        symbol = "🔒 ";
        disabled = false;
        format = "[$symbol]($style)";
      };

      line_break = {
        disabled = false;
      };

      container = {
        format = "[$symbol \\[$name\\]]($style) ";
      };

      jobs = {
        symbol = "🔄 ";
        format = "[$symbol$number]($style) ";
        style = "bold dimmed";
      };
    };
  };
}
