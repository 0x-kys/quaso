{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    nushell = {
      enable = true;
      # configFile.source = ./nushell/config.nu;
      extraConfig = ''
        # Disable banner
        $env.config = {
          show_banner: false
        }

        # Toggle in-built keyboard
        def kb-toggle [] {
            let status_file = $"($env.XDG_RUNTIME_DIR)/keyboard.status"

            if not ($status_file | path exists) {
                "true" | save $status_file
                ^hyprctl notify -1 2500 "rgb(ff0000)" "fontsize:16 Enabled Keyboard"
                ^hyprctl keyword '$LAPTOP_KB_ENABLED' "true" -r
            } else {
                let current_status = open $status_file
                if $current_status == "true" {
                    "false" | save $status_file
                    ^hyprctl notify -1 2500 "rgb(ff0000)" "fontsize:16 Disabled Keyboard"
                    ^hyprctl keyword '$LAPTOP_KB_ENABLED' "false" -r
                } else {
                    "true" | save $status_file
                    ^hyprctl notify -1 2500 "rgb(ff0000)" "fontsize:16 Enabled Keyboard"
                    ^hyprctl keyword '$LAPTOP_KB_ENABLED' "true" -r
                }
            }
        }

        # Check status of in-built keyboard
        def kb-status [] {
            let status_file = $"($env.XDG_RUNTIME_DIR)/keyboard.status"
            if ($status_file | path exists) {
                open $status_file
            } else {
                echo "unknown"
            }
        }

        $env.PATH = ($env.PATH | prepend $"($env.HOME)/.bun/bin")
      '';
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
      style = ''
                * {
                font-family: Iosevka Nerd Font;
                font-size: 10pt;
        }

        window {
                margin: 0px;
                border: 1px solid #5E5E5E;
                background-color: #0d0c0d;
                border-radius: 8px;
        }

        #input {
                margin: 5px;
                border: none;
                background-color: #0d0c0d;
                color: #FFFFFF;
        }

        #inner-box {
                margin: 5px;
                border: none;
                background-color: transparent;
        }

        #outer-box {
                margin: 0px;
                border: none;
                background-color: transparent;
        }

        #scroll {
                margin: 0px;
                border: none;
        }

        #text {
                margin: 5px;
                border: none;
                color: #FFFFFF;
        }

        #entry {
                border-radius: 5px;
        }

        #entry:selected {
                background-color: #5E5E5E;
        }

        window {
                box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.33);
        }

      '';
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
            space = {
              space = "file_picker";
            };
            esc = ["collapse_selection" "keep_primary_selection"];
          };
        };
        editor = {
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
            language-servers = ["nil" "wakatime-ls"];
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
              command = "${pkgs.prettierd}/bin/prettierd";
              args = ["html"];
            };
            language-servers = ["html-languageserver" "wakatime-ls"];
          }

          # CSS
          {
            name = "css";
            auto-format = true;
            formatter = {
              command = "${pkgs.prettierd}/bin/prettierd";
              args = ["css"];
            };
            language-servers = ["css-languageserver" "wakatime-ls"];
          }

          # JavaScript
          {
            name = "javascript";
            auto-format = true;
            formatter = {
              command = "${pkgs.prettierd}/bin/prettierd";
              args = ["javascript"];
            };
            language-servers = ["typescript-language-server" "wakatime-ls"];
          }

          # TypeScript
          {
            name = "typescript";
            auto-format = true;
            formatter = {
              command = "${pkgs.prettierd}/bin/prettierd";
              args = ["typescript"];
            };
            language-servers = ["typescript-language-server" "wakatime-ls"];
          }

          # Svelte
          {
            name = "svelte";
            auto-format = true;
            formatter = {
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
              args = ["--parser" "svelte"];
            };
            language-servers = ["svelte-language-server" "wakatime-ls"];
          }

          # Astro
          {
            name = "astro";
            auto-format = true;
            formatter = {
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
              args = ["--parser" "astro"];
            };
            language-servers = ["astro-ls" "wakatime-ls"];
          }

          # JSX
          {
            name = "jsx";
            auto-format = true;
            formatter = {
              command = "${pkgs.prettierd}/bin/prettierd";
              args = ["jsx"];
            };
            language-servers = ["typescript-language-server" "wakatime-ls"];
          }

          # TSX
          {
            name = "tsx";
            auto-format = true;
            formatter = {
              command = "${pkgs.prettierd}/bin/prettierd";
              args = ["tsx"];
            };
            language-servers = ["typescript-language-server" "wakatime-ls"];
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
          nil = {
            command = "${pkgs.nil}/bin/nil";
          };
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
          "html-languageserver" = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
            args = ["--stdio"];
          };
          "css-languageserver" = {
            command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
            args = ["--stdio"];
          };
          "typescript-language-server" = {
            command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio"];
          };
          "svelte-language-server" = {
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
        };
      };
    };
  };
}
