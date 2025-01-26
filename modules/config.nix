{
  config,
  pkgs,
  ...
}: let
  configPaths = [
    {
      name = "nvim";
      path = "${config.home.homeDirectory}/.config/nixcfg/nvim";
    }
    {
      name = "glow";
      path = "${config.home.homeDirectory}/.config/nixcfg/glow";
    }
    {
      name = "hypr";
      path = "${config.home.homeDirectory}/.config/nixcfg/hypr";
    }
    {
      name = "waybar";
      path = "${config.home.homeDirectory}/.config/nixcfg/waybar";
    }
    {
      name = "scripts";
      path = "${config.home.homeDirectory}/.config/nixcfg/scripts";
    }
    {
      name = "btop";
      path = "${config.home.homeDirectory}/.config/nixcfg/btop";
    }
    {
      name = "kanshi";
      path = "${config.home.homeDirectory}/.config/nixcfg/kanshi";
    }
  ];
in {
  xdg.configFile = builtins.listToAttrs (map (c: {
      name = c.name;
      value = {
        source = config.lib.file.mkOutOfStoreSymlink c.path;
      };
    })
    configPaths);

  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 96;
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  services = {
    dunst = {
      enable = true;
      package = pkgs.dunst;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          geometry = "200x20-10+10";
          indicate_hidden = "yes";

          background = "#0c0d0c";
          forground = "#c5c5c9";

          font = "0xProto Nerd Font 8";

          enable_recursive_icon_lookup = true;
          icon_position = "left";
          max_icon_size = 48;
          min_icon_size = 24;

          format = "<b>%a</b>\n%s\n%b\n";

          notification_limit = 5;
          timeout = 10;
          sort = "yes";
          stack_duplicates = true;

          mouse_left_click = ["do_action" "close_current"];
          mouse_middle_click = ["close_current"];
          mouse_right_click = ["close_all"];

          layer = "overlay";
          force_wayland = false;

          frame_width = 1;
          frame_color = "#5e5e5e";
          corner_radius = 8;
        };

        urgency_low = {
          background = "#0c0d0c";
          foreground = "#888888";
          timeout = 5;
        };
        urgency_normal = {
          background = "#0c0d0c";
          foreground = "#c5c5c9";
          timeout = 10;
        };
        urgency_critical = {
          background = "#0c0d0c";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 0;
        };
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
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
