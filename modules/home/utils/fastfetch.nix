{pkgs, ...}: {
  programs.fastfetch = {
    enable = true;
  };

  home.file.".config/fastfetch/config.jsonc".source = builtins.path {
    path = ../../../extras/fastfetch/config.jsonc;
    name = "fastfetch-config";
  };
}
