{
  pkgs,
  config,
  ...
}: {
  home = {
    file = {
      ".icons/WhiteSur-cursors" = {
        source = "${pkgs.whitesur-cursors}/share/icons/WhiteSur-cursors";
        recursive = true;
      };
    };
  };

  xdg.configFile = let
    configDir = "${config.home.homeDirectory}/.config/nixcfg";
    configPaths = [
      {
        name = "glow";
        path = "${configDir}/extras/glow";
      }
      {
        name = "wlppr";
        path = "${configDir}/extras/wlppr";
      }
      {
        name = "scripts";
        path = "${configDir}/extras/scripts";
      }
      {
        name = "btop";
        path = "${configDir}/extras/btop";
      }
      # {name = "emacs"; path = "${configDir}/extras/emacs";}
      # {name = "nushell"; path = "${configDir}/extras/nushell";}
      # {name = "tmux"; path = "${configDir}/extras/tmux";}
      # {name = "waybar"; path = "${configDir}/extras/waybar";}
      # {name = "wofi"; path = "${configDir}/extras/wofi";}
    ];
  in
    builtins.listToAttrs (map (c: {
        name = c.name;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink c.path;
        };
      })
      configPaths);
}
