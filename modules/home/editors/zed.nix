{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extensions = [
      "nix"
      "html"
      "toml"
      "sql"
      "latex"
      "svelte"
      "zig"
      "lua"
      "scss"
      "astro"
      "emmet"
      "env"
      "basher"
      "kanagawa-themes"
      "ini"
      "golangci-lint"
      "liveserver"
      "scheme"
      "material-icon-theme"
      "base16"
      "tailwind-syntax"
      "wakatime"
      "tmux"
      "elisp"
      "nu"
      "gruvbox-material"
      "mermaid"
      "go-sum-highlighting"
    ];
    extraPackages = with pkgs; [
      nixd
      alejandra
      rust-analyzer
      tailwindcss-language-server
      vscode-langservers-extracted
      typescript-language-server
      nodePackages.svelte-language-server
      astro-language-server
      marksman
      nil
      zls
      gopls
      taplo
      deno
      nodePackages.prettier
    ];
    userSettings = {
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      vim_mode = true;
      relative_line_numbers = true;
      ui_font_size = 14;
      buffer_font_size = 14;
      buffer_font_family = "0xProto Nerd Font";
      current_line_highlight = "gutter";
      scrollbar = {
        show = "auto";
        cursors = true;
        git_diff = true;
        search_results = true;
        selected_symbols = true;
        diagnostics = "all";
        axes = {
          horizontal = true;
          vertical = true;
        };
      };
      enable_language_server = true;
      ensure_final_newline_on_save = true;
      use_autoclose = false;
      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = false;
        };
      };
      indent_guides = {
        enabled = true;
        line_width = 1;
        active_line_width = 2;
        coloring = "fixed";
        background_coloring = "disabled";
      };
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
        show_background = false;
      };
      hour_format = "hour12";
      soft_wrap = "editor_width";
      show_wrap_guides = true;

      languages = {
        c = {
          format_on_save = "on";
          preferred_line_length = 64;
          soft_wrap = "preferred_line_length";
          remove_trailing_whitespace_on_save = true;
        };
        nix = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
        };
        rust = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.rustfmt}/bin/rustfmt";
          };
        };
        html = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "html"];
          };
        };
        css = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "css"];
          };
        };
        javascript = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "js"];
          };
        };
        typescript = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "ts"];
          };
        };
        svelte = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--plugin" "prettier-plugin-svelte" "--parser" "svelte"];
          };
        };
        astro = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--plugin" "prettier-plugin-astro" "--parser" "astro"];
          };
        };
        jsx = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "jsx"];
          };
        };
        tsx = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "tsx"];
          };
        };
        json = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "json"];
          };
        };
        jsonc = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "jsonc"];
          };
        };
        toml = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.taplo}/bin/taplo";
            args = ["format" "-"];
          };
        };
        markdown = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.deno}/bin/deno";
            args = ["fmt" "-" "--ext" "md"];
          };
        };
        zig = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.zls}/bin/zls";
            args = ["--format"];
          };
        };
        go = {
          format_on_save = "on";
          formatter = {
            command = "${pkgs.gofumpt}/bin/gofumpt";
          };
        };
      };

      lsp = {
        "rust-analyzer" = {
          binary = {
            path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
          initialization_options = {
            check = {
              command = "clippy";
            };
          };
        };
        "nil" = {
          binary = {
            path = "${pkgs.nil}/bin/nil";
          };
        };
        "tailwindcss-language-server" = {
          binary = {
            path = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
            arguments = ["--stdio"];
          };
        };
        "vscode-html-language-server" = {
          binary = {
            path = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
            arguments = ["--stdio"];
          };
        };
        "vscode-css-language-server" = {
          binary = {
            path = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
            arguments = ["--stdio"];
          };
        };
        "typescript-language-server" = {
          binary = {
            path = "${pkgs.typescript-language-server}/bin/typescript-language-server";
            arguments = ["--stdio"];
          };
        };
        "svelte-language-server" = {
          binary = {
            path = "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver";
            arguments = ["--stdio"];
          };
        };
        "astro-language-server" = {
          binary = {
            path = "${pkgs.astro-language-server}/bin/astro-ls";
            arguments = ["--stdio"];
          };
        };
        "marksman" = {
          binary = {
            path = "${pkgs.marksman}/bin/marksman";
          };
        };
        "zls" = {
          binary = {
            path = "${pkgs.zls}/bin/zls";
          };
        };
        "gopls" = {
          binary = {
            path = "${pkgs.gopls}/bin/gopls";
            arguments = ["serve"];
          };
        };
      };

      edit_predictions = {
        disabled_globs = [
          "**/.env*"
          "**/*.pem"
          "**/*.key"
          "**/*.cert"
          "**/*.crt"
          "**/secrets.yml"
        ];
      };
      edit_predictions_disabled_in = ["comments" "string"];
    };
  };
}
