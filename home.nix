{pkgs, ...}: {
  imports = [
    ./modules/home/files.nix
    ./modules/home/packages.nix
    ./modules/home/desktop/hyprland.nix
    ./modules/home/desktop/waybar.nix
    ./modules/home/desktop/wofi.nix
    ./modules/home/desktop/dunst.nix
    ./modules/home/editors/neovim.nix
    ./modules/home/editors/helix.nix
    ./modules/home/editors/zed.nix
    ./modules/home/editors/emacs.nix
    ./modules/home/shells/nushell.nix
    ./modules/home/shells/starship.nix
    ./modules/home/terminals/ghostty.nix
    ./modules/home/terminals/tmux.nix
    ./modules/home/utils/bat.nix
    ./modules/home/utils/fastfetch.nix
    ./modules/home/utils/git.nix
    ./modules/shared/config.nix
  ];

  home = {
    username = ""; # TODO: YOUR USERNAME
    homeDirectory = "/home/<username>"; # TODO: YOUR HOME DIRECTORY PATH
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
