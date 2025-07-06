{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/hardware.nix
    ./modules/system/networking.nix
    ./modules/system/services.nix
    ./modules/system/users.nix
    ./modules/shared/fonts.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  time = {
    timeZone = "Asia/Kolkata";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs.fish.enable = true;
  programs.adb.enable = true;

  system = {
    stateVersion = "24.11";
  };
}
