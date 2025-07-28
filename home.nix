{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./modules/home/files.nix
    ./modules/home/packages.nix
    ./modules/home/desktop/hyprland.nix
    ./modules/home/desktop/waybar.nix
    ./modules/home/desktop/wofi.nix
    ./modules/home/desktop/dunst.nix
    ./modules/home/desktop/swaync.nix
    ./modules/home/editors/neovim.nix
    ./modules/home/editors/zed.nix
    ./modules/home/editors/vscode.nix
    ./modules/home/shells/fish.nix
    ./modules/home/shells/starship.nix
    ./modules/home/terminals/ghostty.nix
    ./modules/home/terminals/tmux.nix
    ./modules/home/utils/bat.nix
    ./modules/home/utils/fastfetch.nix
    ./modules/home/utils/git.nix
    ./modules/home/utils/cava.nix
    ./modules/home/utils/yazi.nix
    ./modules/shared/config.nix
  ];

  home = {
    username = "syk";
    homeDirectory = "/home/syk";
    stateVersion = "24.11";
  };

  home.sessionVariables = {
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
  };

  programs.home-manager.enable = true;
}
