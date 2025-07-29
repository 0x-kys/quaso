{pkgs, ...}: {
  security = {
    rtkit = {
      enable = true;
    };
    polkit = {
      enable = true;
    };
  };
  programs.xwayland = {
    enable = true;
  };

  services = {
    dbus = {
      enable = true;
    };
    udev = {
      enable = true;
      packages = [pkgs.android-udev-rules];
    };
    # gnome = {
    #   gnome-keyring = {
    #     enable = true;
    #   };
    # };
    passSecretService = {
      enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    udisks2 = {
      enable = true;
    };
    printing = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
      };
      jack = {
        enable = false;
      };
      wireplumber = {
        enable = true;
      };
    };
    pulseaudio = {
      enable = false;
    };
    openssh = {
      enable = true;
    };
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
      touchpad = {
        accelProfile = "flat";
      };
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      enableTCPIP = true;
      port = 5432;
      ensureDatabases = ["postgres" "myorbit"];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database DBuser auth-method
        local all      all     md5
        # ipv4
        host  all      all     127.0.0.1/32   md5
        # ipv6
        host  all      all     ::1/128        md5
      '';
      extensions = extensions: [
        extensions.pgvector
        extensions.postgis
      ];
    };
    redis = {
      enable = true;
      bind = "0.0.0.0"; # Listen on all interfaces (default: localhost)
      port = 6379; # Default Redis port
      settings = {
        save = ["900 1" "300 10" "60 10000"]; # Snapshot settings
        maxmemory = "256mb"; # Limit memory usage (optional)
        maxmemory-policy = "allkeys-lru"; # Eviction policy
        appendonly = "yes"; # Enable AOF persistence
      };
    };
    getty = {
      autologinUser = null;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    mtr = {
      enable = true;
    };
    nix-ld = {
      enable = true;
    };
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    variables = {
      EDITOR = "nvim";
      XCURSOR_THEME = "WhiteSur-cursors";
      XCURSOR_SIZE = "24";
    };
    systemPackages = with pkgs; [
      android-studio
      vesktop
      xorg.xinit
      lix
      vim
      curl
      wget
      fzf
      grc
      helix
      pywal
      nushell
      hyprpaper
      swaybg
      swayidle
      wl-clipboard
      wl-clip-persist
      slurp
      grim
      swaylock-effects
      brightnessctl
      helvum
      pavucontrol
      playerctl
      wf-recorder
      gnome-tweaks
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
