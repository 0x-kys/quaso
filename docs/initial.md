after installation edit `/etc/nixos/configuration.nix` and add the following content to enable flakes and install `vim`

```nix
{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # ......

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command,
    # so git must be installed first
    git
    vim
    wget
  ];

  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

  # ......
}
```

**Reference**: [nixos-with-flakes/nixos-with-flakes-enabled#enable-nix-flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled#enable-nix-flakes)

after enabling flakes clone this repo to `~/.config/nixcfg/`, then, use the following command

```sh
cp -r /etc/nixos/hardware-configuration.nix ~/.config/nixcfg/
```

after that

1. Check `modules/system/boot.nix` and read NOTE if needed
2. Check `home.nix` and update your username and home directory path
3. Check `modules/system/networking.nix` and change your hostname if needed (default: nixbook)
4. And finally, check `flake.nix` for NOTE

```sh
cd ~/.config/nixcfg/ && sudo nixos-rebuild switch --flake .#nixbook
```

Wait for some time and after that reboot on login screen enter your username if it prompts and when entering your password go to gear icon on bottom right of login screen and switch to hyprland for better vibe

- win+q to open ghostty
- win+r to open wofi (spotlight)
- win+e for file manager (nautilus)

- neovim keybinds are in `~/.config/nixcfg/extras/neovim/init.lua`

