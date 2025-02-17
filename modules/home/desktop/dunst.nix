{pkgs, ...}: {
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "200x20-10+10";
        indicate_hidden = "yes";

        background = "#1d2021"; # bg
        foreground = "#d5c4a1"; # fg

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
        frame_color = "#928374"; # gray
        corner_radius = 8;
      };

      urgency_low = {
        background = "#1d2021"; # bg
        foreground = "#928374"; # gray
        timeout = 5;
      };
      urgency_normal = {
        background = "#1d2021"; # bg
        foreground = "#d5c4a1"; # fg
        timeout = 10;
      };
      urgency_critical = {
        background = "#1d2021"; # bg
        foreground = "#d5c4a1"; # fg
        frame_color = "#fb4934"; # red
        timeout = 0;
      };
    };
  };
}
