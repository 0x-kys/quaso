{pkgs, ...}: {
  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 96;
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama;
      environmentVariables = {};
      host = "127.0.0.1";
      port = 11434;
    };

    kanshi = {
      enable = true;
      package = pkgs.kanshi;
      settings = [
        {
          profile = {
            name = "laptop";
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                scale = 1.0;
              }
            ];
          };
        }
        {
          profile = {
            name = "external";
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "HDMI-A-1";
                status = "enable";
                mode = "2560x1440@144Hz";
                position = "0,0";
              }
            ];
          };
        }
      ];
    };

    hyprpaper = {
      enable = true;
      package = pkgs.hyprpaper;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [
          "~/.config/nixcfg/wlppr/grv3.jpg"
        ];

        wallpaper = [
          "eDP-1, ~/.config/nixcfg/wlppr/grv3.jpg"
          "HDMI-A-1, ~/.config/nixcfg/wlppr/grv3.jpg"
        ];
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
  };

  qt = {
    enable = true;
    platformTheme = {name = "adwaita";};
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
