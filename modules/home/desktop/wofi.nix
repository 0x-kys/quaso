{pkgs, ...}: {
  programs.wofi = {
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
    style = builtins.readFile ../../../extras/wofi/style.css;
  };
}
