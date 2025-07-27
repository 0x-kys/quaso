{pkgs, ...}: {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;
    config = {
      terminal = "ghostty";
      menu = "wofi --show drun";
      modifier = "Mod4"; # Super key

      # Output configuration
      output = {
        "eDP-1" = {
          resolution = "1920x1080";
          position = "0,0";
          scale = "1";
        };
      };

      # Input configuration
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
        };
        "type:touchpad" = {
          natural_scroll = "disabled";
          tap = "enabled";
        };
      };

      # Visual styling
      gaps = {
        inner = 2;
        outer = 4;
      };

      window = {
        border = 1;
        titlebar = false;
      };

      # Startup applications
      startup = [
        {command = "waybar";}
        {command = "waypaper --restore";}
        {command = "kanshi";}
      ];

      # Workspaces
      workspaceAutoBackAndForth = true;

      # Key bindings
      keybindings = let
        modifier = "Mod4";
      in {
        # Basic actions
        "${modifier}+Return" = "exec ${pkgs.ghostty}/bin/ghostty";
        "${modifier}+c" = "kill";
        "${modifier}+e" = "exec nautilus";
        "${modifier}+r" = "exec wofi --show drun";
        "${modifier}+v" = "floating toggle";
        "${modifier}+m" = "exit";

        # Movement keys
        "${modifier}+Left" = "focus left";
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";

        # Workspace switching
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        # Move containers to workspace
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Scratchpad
        "${modifier}+s" = "scratchpad show";
        "${modifier}+Shift+s" = "move scratchpad";

        # Reload configuration
        "${modifier}+Shift+r" = "reload";

        # Screenshot
        "Print" = "exec grimblast --notify copy area";

        # Layout controls
        "${modifier}+j" = "layout toggle split";
        "${modifier}+p" = "layout tabbed";

        # Media keys
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86MonBrightnessUp" = "exec brightnessctl s 10%+";
        "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPause" = "exec playerctl play-pause";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
      };

      # Mouse bindings
      modes = {
        resize = {
          "Left" = "resize shrink width 10px";
          "Right" = "resize grow width 10px";
          "Up" = "resize shrink height 10px";
          "Down" = "resize grow height 10px";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };

      # Window rules
      window.commands = [
        {
          criteria = {app_id = "org.gnome.Nautilus";};
          command = "floating enable";
        }
        {
          criteria = {app_id = "xdg-desktop-portal-gtk";};
          command = "floating enable";
        }
      ];
    };

    # Extra Sway configuration
    extraConfig = ''
      # Set environment variables
      set $XCURSOR_SIZE 24
      set $XCURSOR_THEME WhiteSur-cursors

      # Disable focus follows mouse
      focus_follows_mouse no

      # Disable window titlebars
      default_border pixel 1
      default_floating_border pixel 1
      hide_edge_borders smart

      # Set colors
      client.focused #5e5e5ecc #5e5e5ecc #ffffff #5e5e5ecc #5e5e5ecc
      client.unfocused #3a3a3a99 #3a3a3a99 #ffffff #3a3a3a99 #3a3a3a99

      # Enable gestures for touchpad
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next
    '';
  };

  # Ensure required packages are installed
  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
    grimblast
    swaylock
    swaybg
    kanshi
  ];
}
