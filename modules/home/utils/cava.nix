{pkgs, ...}: {
  programs.cava = {
    enable = true;
    package = pkgs.cava;
    settings = {
      general.framerate = 60;
      input.method = "pulse";
      smoothing.noise_reduction = 88;
      color = {
        background = "'#1b1b1b'";
        foreground = "'#d5c4a1'";
      };
    };
  };
}
