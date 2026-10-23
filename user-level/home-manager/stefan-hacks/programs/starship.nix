# starship.nix — Home Manager starship prompt (Nerd Font Symbols Preset)
{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      scan_timeout = 10;
      command_timeout = 2000;
      add_newline = true;

      format = "$directory$git_branch$git_status$python$rust$nodejs$nix_shell\n[╰─](dimmed)$character ";
      right_format = "$cmd_duration$time$battery";

      # ── Core ──
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
        read_only = " 󰌾";
        read_only_style = "bold red";
      };

      # ── Git ──
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold yellow";
      };

      git_commit = {
        tag_symbol = "  ";
      };

      # ── Languages ──
      python = {
        symbol = " ";
        format = "[$symbol$pyenv_prefix($version )(\($virtualenv\))]($style)";
        style = "bold yellow";
      };

      rust = {
        symbol = "󱘗 ";
        format = "[$symbol($version )]($style)";
        style = "bold red";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol($version )]($style)";
        style = "bold green";
      };

      nix_shell = {
        symbol = " ";
        format = "[$symbol$state( \\($name\\))]($style) ";
        style = "bold blue";
      };

      # ── Time / duration ──
      time = {
        disabled = false;
        format = "[ $time]($style) ";
        style = "bold dimmed white";
        time_format = "%H:%M";
      };

      cmd_duration = {
        min_time = 500;
        format = "[ took $duration]($style) ";
        style = "bold yellow";
      };

      # ── Battery ──
      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        unknown_symbol = "󰂑 ";
        empty_symbol = "󰂎 ";
        display = [
          { threshold = 10; style = "bold red"; }
          { threshold = 30; style = "bold yellow"; }
          { threshold = 100; style = "bold green"; }
        ];
      };

      # ── Status / sudo ──
      status = {
        style = "bg:blue";
        symbol = " ";
        success_symbol = " ";
        format = "[\\[$symbol$common_meaning$signal_name$maybe_int\\]]($style) ";
        map_symbol = true;
        disabled = false;
      };

      sudo = {
        style = "bold red";
        symbol = " ";
        disabled = false;
        format = "[$symbol]($style)";
      };

      line_break = {
        disabled = false;
      };

      container = {
        symbol = " ";
        format = "[$symbol \\[$name\\]]($style) ";
      };

      jobs = {
        symbol = "󰹍 ";
        format = "[$symbol$number]($style) ";
        style = "bold dimmed";
      };

      # ── Nerd Font Symbols Preset (additional modules) ──
      aws.symbol = " ";
      azure.symbol = " ";
      buf.symbol = " ";
      bun.symbol = " ";
      c.symbol = " ";
      cpp.symbol = " ";
      cmake.symbol = " ";
      cobol.symbol = " ";
      conda.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";
      deno.symbol = " ";
      direnv.symbol = " ";
      docker_context.symbol = " ";
      dotnet.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      erlang.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      gcloud.symbol = "󱇶 ";
      gleam.symbol = " ";
      golang.symbol = " ";
      gradle.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      helm.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = " ";
      nixos.symbol = " ";
      ocaml.symbol = " ";
      opa.symbol = " ";
      openstack.symbol = " ";
      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = " ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = " ";
        Kali = " ";
        Linux = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = " ";
        openSUSE = " ";
        OracleLinux = "󰺡 ";
        Pop = " ";
        Raspbian = " ";
        RedHatEnterprise = "󱄛 ";
        Redhat = "󱄛 ";
        Redox = "󰀘 ";
        RockyLinux = " ";
        Solus = " ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Windows = "󰍲 ";
      };
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      pijul_channel.symbol = " ";
      pixi.symbol = "󰏗 ";
      pulumi.symbol = " ";
      purescript.symbol = " ";
      raku.symbol = "󱖊 ";
      red.symbol = "󱍼 ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      scala.symbol = " ";
      shlvl.symbol = "󰹍 ";
      singularity.symbol = " ";
      solidity.symbol = " ";
      spack.symbol = " ";
      swift.symbol = " ";
      terraform.symbol = " ";
      typst.symbol = " ";
      vagrant.symbol = " ";
      vlang.symbol = " ";
      zig.symbol = " ";
    };
  };
}
