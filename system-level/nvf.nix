# nvf — Modular Neovim configuration framework for NixOS.
# Docs: https://nvf.notashelf.dev/
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.nixosModules.nvf
  ];

  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = {
      # ── Aliases ──
      viAlias = true;
      vimAlias = true;

      # ── Editor options ──
      options = {
        number = true;
        relativenumber = true;
        cursorline = true;
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
        smartindent = true;
        termguicolors = true;
        clipboard = "unnamedplus";
      };

      # ── Spellcheck ──
      spellcheck = {
        enable = true;
        programmingWordlist.enable = true;
      };

      # ── Theme ──
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };

      # ── Status line ──
      statusline.lualine = {
        enable = true;
        setupOpts.options.theme = "catppuccin";
        integrations.breadcrumbs = {
          vanilla.enable = false;
          nvim-navic.enable = true;
          navbuddy.enable = true;
          lspsaga.enable = false;
        };
      };

      # ── Autocompletion (blink-cmp for maximal) ──
      autocomplete = {
        nvim-cmp.enable = false;
        blink-cmp.enable = true;
      };
      snippets.luasnip.enable = true;

      # ── Autopairs ──
      autopairs.nvim-autopairs.enable = true;

      # ── Fuzzy finder ──
      telescope.enable = true;

      # ── File tree ──
      filetree.neo-tree.enable = true;

      # ── Tabline ──
      tabline.nvimBufferline.enable = true;

      # ── Git ──
      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
        neogit.enable = true;
      };

      # ── Treesitter ──
      treesitter.context.enable = true;

      # ── Keybind helpers ──
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      # ── LSP ──
      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = false;
        otter-nvim.enable = true;
        nvim-docs-view.enable = true;
        presets.harper.enable = true;
      };

      # ── Debugger ──
      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      # ── Languages (maximal bundled configuration) ──
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        # Core languages (enabled in default + maximal)
        nix.enable = true;
        markdown.enable = true;

        # Languages enabled in maximal configuration
        bash.enable = true;
        clang.enable = true;
        cmake.enable = true;
        css.enable = true;
        scss.enable = true;
        html.enable = true;
        json.enable = true;
        sql.enable = true;
        java.enable = true;
        kotlin.enable = true;
        typescript.enable = true;
        go.enable = true;
        lua.enable = true;
        zig.enable = true;
        python.enable = true;
        typst.enable = true;
        rust = {
          enable = true;
          extensions.rustaceanvim.enable = false;
          extensions.crates-nvim.enable = true;
        };
        toml.enable = true;
        xml.enable = true;
        tex.enable = true;
        docker.enable = true;
        env.enable = true;

        # Less common languages (disabled by default in maximal)
        arduino.enable = false;
        assembly.enable = false;
        astro.enable = false;
        awk.enable = false;
        beancount.enable = false;
        csharp.enable = false;
        dart.enable = false;
        elixir.enable = false;
        fish.enable = false;
        fluent.enable = false;
        fsharp.enable = false;
        gettext.enable = false;
        gleam.enable = false;
        glsl.enable = false;
        haskell.enable = false;
        hcl.enable = false;
        jinja.enable = false;
        jq.enable = false;
        julia.enable = false;
        just.enable = false;
        liquid.enable = false;
        lisp.enable = false;
        make.enable = false;
        nim.enable = false;
        nu.enable = false;
        ocaml.enable = false;
        openscad.enable = false;
        pug.enable = false;
        qml.enable = false;
        r.enable = false;
        ruby.enable = false;
        scala.enable = false;
        standard-ml.enable = false;
        svelte.enable = false;
        tera.enable = false;
        tsx.enable = false;
        twig.enable = false;
        vala.enable = false;
        vue.enable = false;
        http.enable = false;
        powershell.enable = false;
        protobuf.enable = false;
        zsh.enable = false;
      };

      # ── Visuals ──
      visuals = {
        nvim-scrollbar.enable = true;
        neoscroll-nvim.enable = false;
        twilight-nvim.enable = false;
        satellite-nvim.enable = false;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        blink-indent.enable = true;
        indent-blankline.enable = true;
        cellular-automaton.enable = false;
      };

      # ── Minimap ──
      minimap.minimap-vim.enable = true;

      # ── Dashboard ──
      dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true;
      };

      # ── Notify ──
      notify.nvim-notify.enable = true;

      # ── Projects ──
      projects.project-nvim.enable = true;

      # ── Terminal ──
      terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
      };

      # ── Utility ──
      utility = {
        ccc.enable = false;
        smart-paste-nvim.enable = false;
        guess-indent-nvim.enable = false;
        auto-indent-nvim.enable = false;
        vim-wakatime.enable = false;
        diffview-nvim.enable = true;
        yanky-nvim.enable = false;
        qmk-nvim.enable = false;
        icon-picker.enable = true;
        surround.enable = true;
        leetcode-nvim.enable = true;
        multicursors.enable = true;
        smart-splits.enable = true;
        undotree.enable = true;
        nvim-biscuits.enable = true;
        grug-far-nvim.enable = true;

        motion = {
          hop.enable = true;
          leap.enable = true;
          precognition.enable = true;
        };
        images = {
          image-nvim.enable = false;
          img-clip.enable = true;
        };
      };

      # ── Notes ──
      notes = {
        neorg.enable = false;
        orgmode.enable = false;
        todo-comments.enable = true;
      };

      # ── Comments ──
      comments.comment-nvim.enable = true;

      # ── Assistant ──
      assistant = {
        chatgpt.enable = false;
        copilot = {
          enable = false;
          cmp.enable = true;
        };
        codecompanion-nvim.enable = false;
        avante-nvim.enable = true;
      };

      # ── Session ──
      session.nvim-session-manager.enable = false;

      # ── Gestures ──
      gestures.gesture-nvim.enable = false;

      # ── Presence ──
      presence = {
        neocord.enable = false;
        cord-nvim.enable = false;
      };

      # ── UI enhancements ──
      ui = {
        borders.enable = true;
        dropbar-nvim.enable = false;
        noice.enable = true;
        colorizer.enable = true;
        modes-nvim.enable = false;
        illuminate.enable = true;
        fastaction.enable = true;
        smartcolumn = {
          enable = true;
          setupOpts.custom_colorcolumn = {
            nix = "110";
            ruby = "120";
            java = "130";
            go = ["90" "130"];
          };
        };
      };

      # ── Extra plugins (not bundled with nvf) ──
      extraPlugins = {
        vellum = {
          package = pkgs.runCommand "vellum.nvim" {} ''
            cp -r ${inputs.vellum} $out
            chmod -R +w $out
            rm -f $out/build.lua
          '';
          setup = ''
            require("vellum").setup({ max_width = 100 })
          '';
        };

        kitty-scrollback = {
          package = pkgs.runCommand "kitty-scrollback.nvim" {} ''
            cp -r ${inputs.kitty-scrollback} $out
            chmod -R +w $out
          '';
          setup = ''
            require("kitty-scrollback").setup()
          '';
        };
      };
    };
  };
}
