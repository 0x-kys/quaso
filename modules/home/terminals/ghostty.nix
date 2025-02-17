{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      theme = "GruvboxDarkHard";
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
      adjust-cell-height = "12%";
      adjust-cell-width = "2%";
      gtk-single-instance = true;
    };
  };
}
