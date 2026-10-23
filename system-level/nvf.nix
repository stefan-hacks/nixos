# nvf — Modular Neovim configuration framework for NixOS.
# Docs: https://nvf.notashelf.dev/
{ config, lib, pkgs, inputs, ... }:

{
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
      };

      # ── Autocompletion ──
      autocomplete.nvim-cmp.enable = true;
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
        lspkind.enable = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      # ── Debugger ──
      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      # ── Languages ──
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        markdown.enable = true;
        bash.enable = true;
        clang.enable = true;
        cmake.enable = true;
        css.enable = true;
        scss.enable = true;
        html.enable = true;
        json.enable = true;
        sql.enable = true;
        typescript.enable = true;
        go.enable = true;
        lua.enable = true;
        python.enable = true;
        rust = {
          enable = true;
          extensions.rustaceanvim.enable = false;
          extensions.crates-nvim.enable = true;
        };
        toml.enable = true;
        xml.enable = true;
        yaml.enable = true;
        docker.enable = true;
        env.enable = true;
        zig.enable = true;
      };

      # ── Visuals ──
      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };

      # ── Minimap ──
      minimap.minimap-vim.enable = true;

      # ── Dashboard ──
      dashboard.alpha.enable = true;

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
        diffview-nvim.enable = true;
        surround.enable = true;
        undotree.enable = true;
        smart-splits.enable = true;
        multicursors.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = true;
        };
      };

      # ── Notes ──
      notes.todo-comments.enable = true;

      # ── Comments ──
      comments.comment-nvim.enable = true;

      # ── UI enhancements ──
      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        illuminate.enable = true;
        fastaction.enable = true;
        smartcolumn = {
          enable = true;
          setupOpts.custom_colorcolumn = {
            nix = "110";
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
      };
    };
  };
}
