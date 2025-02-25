{inputs, ...}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    theme = "gruvbox_vivid";

    layout = {
      "bar.layouts" = {
        "*" = {
          left = ["dashboard" "workspaces" "windowtitle"];
          middle = [];
          right = ["media" "volume" "network" "bluetooth" "battery" "clock" "systray" "power" "notifications"];
        };
      };
    };

    override = {
      # Background and general theme
      "theme.bar.background" = "#1b1b1b";
      "theme.bar.menus.background" = "#1b1b1b";
      "theme.foreground" = "#d5c4a1";
      "theme.bar.text" = "#d5c4a1";

      # Workspace buttons
      "theme.bar.buttons.workspaces.hover" = "#928374"; # Gruvbox gray
      "theme.bar.buttons.workspaces.active" = "#fabd2f"; # Gruvbox yellow
      "theme.bar.buttons.workspaces.occupied" = "#b8bb26"; # Gruvbox green
      "theme.bar.buttons.workspaces.available" = "#665c54"; # Gruvbox dark gray
      "theme.bar.buttons.workspaces.border" = "#1d2021"; # Updated to Gruvbox dark bg

      # Bar border
      "theme.bar.border.color" = "#1d2021"; # Gruvbox blue

      # OSD and other UI elements
      "theme.osd.orientation" = "vertical";
      "theme.osd.location" = "right";

      # Custom interactions
      "bar.customModules.cava.showIcon" = true;

      # Power menu styling
      "theme.bar.menus.menu.power.radius" = "0.4em";
      "theme.bar.buttons.modules.power.spacing" = "0.45em";

      # Font
      "theme.font.name" = "JetBrainsMono Nerd Font";
    };

    settings = {
      bar.autoHide = "fullscreen";
      notifications.position = "top";
      theme.bar.buttons.workspaces.numbered_active_highlight_padding = "0.4em";
      bar.workspaces.numbered_active_indicator = "highlight";
      theme.bar.buttons.workspaces.spacing = "0.5em";
      theme.bar.buttons.clock.enableBorder = true;
      theme.bar.buttons.systray.enableBorder = true;
      theme.bar.buttons.background_hover_opacity = 80;
      theme.bar.buttons.innerRadiusMultiplier = "0.4";
      theme.bar.buttons.radius = "0.5em";
      theme.bar.buttons.y_margins = "0.8em";
      theme.bar.buttons.padding_y = "0.1rem";
      theme.bar.buttons.padding_x = "0.7rem";
      theme.bar.buttons.spacing = "0.25em";
      theme.bar.border.location = "full";
      theme.bar.buttons.workspaces.enableBorder = true;
      theme.bar.buttons.modules.power.enableBorder = true;
      theme.bar.buttons.dashboard.enableBorder = true;
      theme.bar.border.width = "0.1em";
      theme.bar.outer_spacing = "1.0em";
      theme.bar.label_spacing = "0.5em";
      theme.bar.border_radius = "0.6em";
      theme.bar.margin_sides = "14.5em";
      theme.bar.margin_bottom = "0em";
      theme.bar.margin_top = "0.2em";
      theme.bar.layer = "overlay";
      theme.bar.opacity = 100;
      theme.bar.scaling = 85;
      theme.osd.scaling = 80;
      theme.tooltip.scaling = 80;
      theme.notification.scaling = 80;
      theme.bar.menus.menu.battery.scaling = 80;
      theme.bar.menus.menu.bluetooth.scaling = 80;
      theme.bar.menus.menu.clock.scaling = 80;
      theme.bar.menus.menu.dashboard.scaling = 70;
      theme.bar.menus.menu.dashboard.confirmation_scaling = 80;
      theme.bar.menus.menu.media.scaling = 80;
      theme.bar.menus.menu.notifications.scaling = 80;
      theme.bar.menus.menu.volume.scaling = 80;
      theme.bar.menus.popover.scaling = 80;
      theme.bar.location = "top";
      theme.bar.buttons.workspaces.pill.radius = "0.9rem * 0.2";
      theme.bar.buttons.workspaces.pill.height = "4em";
      theme.bar.buttons.workspaces.pill.width = "6em";
      theme.bar.buttons.workspaces.pill.active_width = "14em";
      menus.dashboard.directories.left.directory1.command = "bash -c \"xdg-open $HOME/Downloads/\"";
      menus.dashboard.directories.left.directory1.label = "󰉍 Downloads";
      menus.dashboard.directories.left.directory2.command = "bash -c \"xdg-open $HOME/Videos/\"";
      menus.dashboard.directories.left.directory2.label = "󰉏 Videos";
      menus.dashboard.directories.left.directory3.command = "bash -c \"xdg-open $HOME/Projects/\"";
      menus.dashboard.directories.left.directory3.label = "󰚝 Projects";
      menus.dashboard.directories.right.directory1.command = "bash -c \"xdg-open $HOME/Documents/\"";
      menus.dashboard.directories.right.directory1.label = "󱧶 Documents";
      menus.dashboard.directories.right.directory2.command = "bash -c \"xdg-open $HOME/Pictures/\"";
      menus.dashboard.directories.right.directory2.label = "󰉏 Pictures";
      menus.dashboard.directories.right.directory3.command = "bash -c \"xdg-open $HOME/\"";
      menus.dashboard.directories.right.directory3.label = "󱂵 Home";
      bar.customModules.updates.pollingInterval = 1440000;
      bar.launcher.icon = "❄️";
      theme.bar.floating = true;
      theme.bar.buttons.enableBorders = false;
      bar.clock.format = "%d/%m/%y  %I:%M %p";
      bar.media.show_active_only = false;
      bar.notifications.show_total = true;
      bar.battery.hideLabelWhenFull = true;
      menus.dashboard.controls.enabled = true;
      menus.dashboard.shortcuts.enabled = true;
      menus.dashboard.shortcuts.right.shortcut1.command = "sleep 0.5 && hyprpicker -a";
      menus.media.displayTime = true;
      menus.power.lowBatteryNotification = true;
      bar.customModules.updates.updateCommand = "jq '[.[].cvssv3_basescore | to_entries | add | select(.value > 5)] | length' <<< $(vulnix -S --json)";
      bar.customModules.updates.icon.updated = "󰋼";
      bar.customModules.updates.icon.pending = "󰋼";
      bar.volume.rightClick = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      bar.volume.middleClick = "pavucontrol";
      bar.media.format = "{title}";
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      bar.workspaces.ignored = "[-99]";
      bar.workspaces.spacing = 1.2;
      theme.font.size = "1rem";
      bar.workspaces.monitorSpecific = false;
      bar.workspaces.workspaces = 3;
      bar.workspaces.applicationIconEmptyWorkspace = "";
      bar.workspaces.applicationIconFallback = "";
      bar.workspaces.showApplicationIcons = false;
      bar.workspaces.showWsIcons = true;
      bar.workspaces.workspaceMask = false; # Disable masking to show only active/inactive
      tear = true;
      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };
      menus.dashboard.directories.enabled = true;
      menus.dashboard.stats.enable_gpu = false;
      theme.bar.transparent = false;
    };
  };
}
