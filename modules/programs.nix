{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs;
      extraPackages = epkgs: [
        epkgs.use-package
        epkgs.evil
        epkgs.evil-collection
        epkgs.general
        epkgs.doom-themes
        epkgs.flycheck
        epkgs.lsp-ui
        epkgs.company
        epkgs.projectile
        epkgs.ivy
        epkgs.which-key
        epkgs.highlight-indent-guides
        epkgs.nix-mode
        epkgs.web-mode
        epkgs.typescript-mode
        epkgs.svelte-mode
        epkgs.go-mode
        epkgs.zig-mode
        epkgs.rust-mode
        epkgs.page-break-lines
        epkgs.dashboard
      ];
      extraConfig = builtins.readFile ../extras/emacs/config.el;
    };

    tmux = {
      enable = true;
      package = pkgs.tmux;
      baseIndex = 1;
      clock24 = false;
      keyMode = "vi";
      mouse = true;
      newSession = false;
      terminal = "screen-256color";
      historyLimit = 9999;

      prefix = "C-Space";

      extraConfig = builtins.readFile ../extras/tmux/tmux.conf;

      plugins = with pkgs; [
        tmuxPlugins.cpu
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '30'
          '';
        }
        {
          plugin = tmuxPlugins.sensible;
          extraConfig = "set -g @plugin 'tmux-plugins/tmux-sensible'";
        }
        {
          plugin = tmuxPlugins.vim-tmux-navigator;
          extraConfig = "set -g @plugin 'christoomey/vim-tmux-navigator'";
        }
      ];
    };

    waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 38;

          modules-left = ["cpu" "memory" "temperature" "hyprland/workspaces"];
          modules-center = [];
          modules-right = ["pulseaudio" "network" "battery" "clock" "group/expand" "tray"];

          "hyprland/workspaces" = {
            format = "{icon}";
            on-click = "activate";
            all-outputs = true;
            show-special = false;
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              "10" = "十";
            };
          };

          "tray" = {
            icon-size = 16;
            spacing = 10;
          };

          "pulseaudio" = {
            format = " {volume}%";
            format-muted = " Muted";
            format-icons = {
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };

          "network" = {
            format-wifi = " {essid}";
            format-ethernet = "󰈀 {ifname}";
            format-disconnected = "";
            tooltip-format = "{ifname} via {gwaddr}";
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
            tooltip-format-ethernet = "{ifname}";
            tooltip-format-disconnected = "Disconnected";
            max-length = 50;
          };

          "cpu" = {
            format = " {usage}%";
            tooltip = true;
            interval = 1;
          };

          "memory" = {
            format = " {}%";
            tooltip-format = "{used:0.1f}GB/{total:0.1f}GB";
          };

          "temperature" = {
            critical-threshold = 80;
            hwmon-path = ["/sys/class/hwmon/hwmon0/temp1_input"];
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" ""];
          };

          "battery" = {
            states = {
              good = 80;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-icons = ["" "" "" "" ""];
          };

          "clock" = {
            format = "{:%I:%M %p}";
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "<tt>{calendar}</tt>";
            calendar = {
              mode = "month";
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b>{}</b></span>";
              };
            };
          };

          "group/expand" = {
            orientation = "horizontal";
            drawer = {
              transition-duration = 600;
              transition-to-left = true;
              click-to-reveal = true;
            };
            modules = [
              "custom/expand"
              "custom/swaylock"
              "custom/suspend"
              "custom/hibernate"
              "custom/reboot"
              "custom/exit_hyprland"
              "custom/endpoint"
            ];
          };

          "custom/expand" = {
            format = "";
            tooltip = false;
          };
          "custom/endpoint" = {
            format = "|";
            tooltip = false;
          };
          "custom/swaylock" = {
            format = "󰌾";
            on-click = "swaylock --screenshots --clock --datestr \"%a %e.%m.%Y\" --timestr \"%I:%M %p\" --effect-blur 10x2 --indicator";
            tooltip = false;
          };
          "custom/suspend" = {
            format = "󰒲";
            on-click = "systemctl suspend";
            tooltip = false;
          };
          "custom/hibernate" = {
            format = "󰤄";
            on-click = "systemctl hibernate";
            tooltip = false;
          };
          "custom/reboot" = {
            format = "󰑓";
            on-click = "systemctl reboot";
            tooltip = false;
          };
          "custom/exit_hyprland" = {
            format = "󰈸";
            on-click = "hyprctl dispatch exit";
            tooltip = false;
          };
        };
      };

      style = builtins.readFile ../extras/waybar/style.css;
    };

    nushell = {
      enable = true;
      extraConfig = builtins.readFile ../extras/nushell/config.nu;
      shellAliases = {
        glog = "git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'";
      };
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = true;

        # Your custom settings for Starship
        "$schema" = "https://starship.rs/config-schema.json";

        bun = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        c = {
          format = "\\[[$symbol($version(-$name))]($style)\\]";
        };

        cmake = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        cmd_duration = {
          format = "\\[[$duration]($style)\\]";
        };

        conda = {
          format = "\\[[$symbol$environment]($style)\\]";
        };

        deno = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        docker_context = {
          format = "\\[[$symbol$context]($style)\\]";
        };

        dotnet = {
          format = "\\[[$symbol($version)(🎯 $tfm)]($style)\\]";
        };

        gcloud = {
          format = "\\[[$symbol$account(@$domain)(\($region\))]($style)\\]";
        };

        git_branch = {
          format = "\\[[$symbol$branch]($style)\\]";
        };

        git_status = {
          format = "(\\[[$all_status$ahead_behind\\]]($style))";
        };

        golang = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        hg_branch = {
          format = "\\[[$symbol$branch]($style)\\]";
        };

        java = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        lua = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        meson = {
          format = "\\[[$symbol$project]($style)\\]";
        };

        nim = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        nix_shell = {
          format = "\\[[$symbol$state( \($name\))]($style)\\]";
        };

        nodejs = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        ocaml = {
          format = "\\[[$symbol($version)(\($switch_indicator$switch_name\))]($style)\\]";
        };

        os = {
          format = "\\[[$symbol]($style)\\]";
        };

        package = {
          format = "\\[[$symbol$version]($style)\\]";
        };

        perl = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        php = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        purescript = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        python = {
          format = "\\[[$symbol\${pyenv_prefix}(\${version})(\(\$virtualenv\))]($style)\\]";
        };
        red = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        rust = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        sudo = {
          format = "\\[[$symbol]($style)\\]";
        };

        username = {
          format = "\\[[$user]($style)\\]";
        };

        vagrant = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        zig = {
          format = "\\[[$symbol($version)]($style)\\]";
        };

        solidity = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
      };
    };
    wofi = {
      enable = true;
      package = pkgs.wofi;
      settings = {
        width = 600;
        height = 400;
        background_color = "#0d0c0d";
        border_color = "#5E5E5E";
        text_color = "#FFFFFF";
        border_width = 1;
        border = 1;
        rounding = 8;
        shadow = 1;
        shadow_color = "#00000055";
        shadow_offset_x = 2;
        shadow_offset_y = 2;
        blur = 0;
        font = "Monospace 10";
        key_up = "Up";
        key_down = "Down";
        key_left = "Left";
        key_right = "Right";
        key_activate = "Return";
        key_backspace = "BackSpace";
        allow_images = false;
        allow_markup = true;
        insensitive = true;
      };
      style = builtins.readFile ../extras/wofi/style.css;
    };

    bat = {
      enable = true;
      package = pkgs.bat;
      config = {
        theme = "base16";
        pager = "less -FR";
        map-syntax = [
          "*.jenkinsfile:Groovy"
          "*.props:Java Properties"
        ];
      };
    };

    ghostty = {
      enable = true;
      package = pkgs.ghostty;
      settings = {
        theme = "Kanagawa Dragon";
        font-size = 10;
        font-family = "0xProto Nerd Font";
        keybind = [
          "ctrl+h=goto_split:left"
          "ctrl+l=goto_split:right"
        ];
        window-decoration = false;
        gtk-titlebar = false;
        window-padding-x = 8;
        window-padding-y = 8;
        window-inherit-working-directory = true;
        copy-on-select = true;
        adjust-underline-position = 4;
        mouse-hide-while-typing = true;
        mouse-scroll-multiplier = 1;
        cursor-invert-fg-bg = true;
        selection-invert-fg-bg = true;
        bold-is-bright = true;
        cursor-style = "underline";
        background-opacity = 1;
        background = "0d0c0d";
        foreground = "c5c5c9";
        adjust-cell-height = "12%";
        adjust-cell-width = "2%";
        gtk-single-instance = true;
      };
      themes = {
        kanagawa-dragon = {
          background = "0d0c0d";
          foreground = "c5c5c9";
        };
      };
    };

    fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nix";
          padding = {
            right = 2;
          };
        };
        display = {
          size = {
            binaryPrefix = "si";
          };
          color = "blue";
          separator = "  ";
        };
        modules = [
          # System information
          "os"
          "kernel"

          "break"
          "cpu"
          "gpu"
          "break"
          "memory"
          "break"
          "terminal"
          "wm"
          "de"
          "break"
          # Date and time
          {
            type = "datetime";
            key = "Date";
            format = "{1}-{3}-{11}"; # YYYY-MM-DD
          }
          {
            type = "datetime";
            key = "Time";
            format = "{14}:{17} {20}"; # HH:MM AM/PM
          }
          "break"
          # Media information
          "player"
          "media"
        ];
      };
    };

    git = {
      enable = true;

      aliases = {
        # Basic shortcuts
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        df = "diff";
        dc = "diff --cached";

        # Log formatting
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        last = "log -1 HEAD";

        # Commit management
        amend = "commit --amend";
        unstage = "reset HEAD --";
        undo = "reset HEAD~1";
        wip = "commit -a -m 'WIP'";
        wipe = "!git add -A && git commit -m 'WIP' && git reset HEAD~1";

        # Update and sync
        up = "pull --rebase";
        sync = "!git pull --rebase && git push";

        # Stash shortcuts
        spush = "stash push";
        spop = "stash pop";
        sshow = "stash show -p";

        # Show ignored files
        ignored = "!git ls-files -v | grep '^[[:lower:]]'";

        # Show untracked files
        untracked = "ls-files --others --exclude-standard";

        # Show all branches (local and remote)
        branches = "branch -a";

        # Delete merged branches
        bdelmerged = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";

        # Pretty print short status
        ss = "status -sb";

        # Show current branch name
        current = "rev-parse --abbrev-ref HEAD";

        # Push current branch
        publish = "!git push -u origin $(git current)";

        # Rebase interactively
        ri = "rebase -i";

        # Reset to origin/main
        resetmain = "!git fetch origin && git reset --hard origin/main";

        # Check current git credentials
        who = "!git config user.name && git config user.email";
      };

      extraConfig = {
        core = {
          editor = "hx";
        };
        pull = {
          rebase = true; # Always rebase when pulling
        };
      };
    };

    home-manager = {
      enable = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "autumn_night_transparent";
        keys = {
          normal = {
            g = {
              r = "goto_reference";
              d = "goto_definition";
            };
            "C-p" = "file_picker";
            space = {
              c = {
                a = "code_action";
              };
              r = {
                n = "rename_symbol";
              };
            };
            esc = ["collapse_selection" "keep_primary_selection"];
          };
        };
        editor = {
          completion-trigger-len = 1; # start completion after typing just one character
          completion-replace = true; # replace existing text with the completion
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "warning";
          };
          gutters = {
            layout = ["diff" "diagnostics" "line-numbers" "spacer"];
            line-numbers = {
              min-width = 1;
            };
          };
          search = {
            smart-case = true;
            wrap-around = true;
          };
          soft-wrap = {
            enable = true;
            max-indent-retain = 0;
          };
          statusline = {
            left = ["mode" "version-control" "spinner"];
            center = ["file-name"];
            right = ["diagnostics" "selections" "position" "position-percentage" "file-encoding" "file-line-ending" "file-type"];
          };
          line-number = "relative";
          lsp = {
            display-messages = true;
            auto-signature-help = true; # automatically show function signature help
            display-inlay-hints = true; # show inlay hints for parameters, types, etc.
          };
          indent-guides = {
            render = true;
            character = "╎"; # Some characters that work well: "▏", "┆", "┊", "⸽"
            skip-levels = 1;
          };
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          whitespace = {
            render = "all";
            characters = {
              space = " ";
              nbsp = "⍽";
              nnbsp = "␣";
              tab = "→";
              newline = "⏎";
              tabpad = " ";
            };
          };
        };
      };
      languages = {
        language = [
          # Nix
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
            };
            language-servers = ["nil-ls" "wakatime-ls"];
          }

          # Rust
          {
            name = "rust";
            auto-format = true;
            formatter = {
              command = "${pkgs.rustfmt}/bin/rustfmt";
            };
            language-servers = ["rust-analyzer" "wakatime-ls"];
          }

          # HTML
          {
            name = "html";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "html"];
            };
            language-servers = ["html-ls" "tailwindcss-ls" "wakatime-ls"];
          }

          # CSS
          {
            name = "css";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "css"];
            };
            language-servers = ["css-ls" "tailwindcss-ls" "wakatime-ls"];
          }

          # JavaScript
          {
            name = "javascript";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "js"];
            };
            language-servers = ["typescript-ls" "wakatime-ls"];
          }

          # TypeScript
          {
            name = "typescript";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "ts"];
            };
            language-servers = ["typescript-ls" "wakatime-ls"];
          }

          # Svelte
          {
            name = "svelte";
            auto-format = true;
            formatter = {
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
              args = ["--plugin" "prettier-plugin-svelte" "--parser" "svelte"];
            };
            language-servers = ["svelte-ls" "tailwindcss-ls" "wakatime-ls"];
          }

          # Astro
          {
            name = "astro";
            auto-format = true;
            formatter = {
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
              args = ["--plugin" "prettier-plugin-astro" "--parser" "astro"];
            };
            language-servers = ["astro-ls" "tailwindcss-ls" "wakatime-ls"];
          }

          # JSX
          {
            name = "jsx";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "jsx"];
            };
            language-servers = ["typescript-ls" "tailwindcss-ls" "wakatime-ls"];
          }

          # TSX
          {
            name = "tsx";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "tsx"];
            };
            language-servers = ["typescript-ls" "tailwindcss-ls" "wakatime-ls"];
          }

          # JSON
          {
            name = "json";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "json"];
            };
            language-servers = ["wakatime-ls"];
          }

          # JSONC
          {
            name = "jsonc";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" "jsonc"];
            };
            language-servers = ["wakatime-ls"];
          }

          # TOML
          {
            name = "toml";
            auto-format = true;
            formatter = {
              command = "${pkgs.deno}/bin/deno";
              args = ["fmt" "-" "--ext" ""];
            };
            language-servers = ["wakatime-ls"];
          }

          # Markdown
          {
            name = "markdown";
            auto-format = true;
            formatter = {
              command = "${pkgs.taplo}/bin/taplo";
              args = ["format" "-"];
            };
            language-servers = ["markdown-ls" "wakatime-ls"];
          }

          # Zig
          {
            name = "zig";
            auto-format = true;
            formatter = {
              command = "${pkgs.zls}/bin/zls";
              args = ["--format"];
            };
            language-servers = ["zls" "wakatime-ls"];
          }

          # Go
          {
            name = "go";
            auto-format = true;
            formatter = {
              command = "${pkgs.gofumpt}/bin/gofumpt";
            };
            language-servers = ["gopls" "wakatime-ls"];
          }
        ];
        language-server = {
          "markdown-ls" = {
            command = "${pkgs.marksman}/bin/marksman";
          };
          "nil-ls" = {
            command = "${pkgs.nil}/bin/nil";
          };
          "rust-analyzer" = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
          "tailwindcss-ls" = {
            command = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
            args = ["--stdio"];
          };
          "html-ls" = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
            args = ["--stdio"];
          };
          "css-ls" = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
            args = ["--stdio"];
          };
          "typescript-ls" = {
            command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio"];
          };
          "svelte-ls" = {
            command = "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver";
            args = ["--stdio"];
          };
          "astro-ls" = {
            command = "${pkgs.astro-language-server}/bin/astro-ls";
            args = ["--stdio"];
          };
          zls = {
            command = "${pkgs.zls}/bin/zls";
          };
          gopls = {
            command = "${pkgs.gopls}/bin/gopls";
            args = ["serve"];
          };
          "wakatime-ls" = {
            command = "${inputs.wakatime-ls.packages.${pkgs.system}.default}/bin/wakatime-ls";
          };
        };
      };
      themes = {
        autumn_night_transparent = {
          "inherits" = "autumn_night";
          "ui.background" = {};

          "type" = {
            "background" = "none";
            "foreground" = "#ffffff";
          };
        };
      };
    };
  };
}
