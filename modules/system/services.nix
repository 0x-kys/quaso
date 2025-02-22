{pkgs, ...}: {
  security = {
    rtkit = {enable = true;};
    polkit = {enable = true;};
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager = {gnome = {enable = true;};};
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    teamviewer = {enable = true;};
    udisks2 = {enable = true;};
    printing = {enable = true;};
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {enable = true;};
      jack = {enable = false;};
      wireplumber = {enable = true;};
    };
    pulseaudio = {enable = false;};
    openssh = {enable = true;};
    libinput = {
      enable = true;
      mouse = {accelProfile = "flat";};
      touchpad = {accelProfile = "flat";};
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {enable = true;};
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    mtr = {enable = true;};
    nix-ld = {enable = true;};
  };

  environment = {
    sessionVariables = {NIXOS_OZONE_WL = "1";};
    variables = {EDITOR = "nvim";};
    systemPackages = with pkgs; [
      vim
      curl
      wget
      fzf
      grc
      helix
      pywal
      nushell
      hyprpaper
      wl-clipboard
      wl-clip-persist
      swaylock-effects
      brightnessctl
      helvum
      pavucontrol
      playerctl
      wf-recorder
      gnome-tweaks
    ];
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland];
    };
  };
}
