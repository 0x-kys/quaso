{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        margin-top = 2;
        margin-left = 2;
        margin-right = 2;
        modules-left = [
          "custom/nixos"
          "cpu"
          "memory"
          "temperature"
        ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "clock"
          "tray"
          "group/expand"
        ];
        "custom/nixos" = {
          format = "󱄅";
          tooltip = false;
        };
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
        "pulseaudio" = {
          format = "󰕾 {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
        };
        "network" = {
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈁 {ifname}";
          format-disconnected = "󰈂";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 15;
        };
        "cpu" = {
          format = " {usage}%";
          tooltip = true;
          interval = 1;
        };
        "memory" = {
          format = " {}%";
          tooltip-format = "{used:0.1f}GB/{total:0.1f}GB";
        };
        "battery" = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = " {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
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
              months = "<span color='#ebdbb2'><b>{}</b></span>";
              weeks = "<span color='#83a598'><b>{}</b></span>";
              weekdays = "<span color='#d79921'><b>{}</b></span>";
              today = "<span color='#fb4934'><b>{}</b></span>";
            };
          };
        };
        "tray" = {
          icon-size = 16;
          spacing = 4;
        };
        "group/expand" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 300;
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
          format = "";
          tooltip = false;
        };
        "custom/endpoint" = {
          format = "";
          tooltip = false;
        };
        "custom/swaylock" = {
          format = "";
          on-click = "swaylock --screenshots --clock --datestr \"%a %e.%m.%Y\" --timestr \"%H:%M\" --effect-blur 10x2 --indicator";
          tooltip = false;
        };
        "custom/suspend" = {
          format = "󰒲";
          on-click = "systemctl suspend";
          tooltip = false;
        };
        "custom/hibernate" = {
          format = "";
          on-click = "systemctl hibernate";
          tooltip = false;
        };
        "custom/reboot" = {
          format = "";
          on-click = "systemctl reboot";
          tooltip = false;
        };
        "custom/exit_hyprland" = {
          format = "";
          on-click = "hyprctl dispatch exit";
          tooltip = false;
        };
      };
    };
    style = builtins.readFile ../../../extras/waybar/style.css;
  };
}
