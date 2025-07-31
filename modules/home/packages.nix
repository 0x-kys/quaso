{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  home = {
    packages = with pkgs; [
      hello
      (writeScriptBin "cow" ''
        #!/usr/bin/env bash
        cowsay $(fortune)
      '')
      onefetch
      gerbv
      teamviewer
      anydesk
      newsflash
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
        ];
      })
      jdk17
      remmina
      nwg-displays
      waypaper
      brave
      spotify
      libreoffice
      obsidian
      playerctl
      tmux
      nnn
      zip
      xz
      unzip
      p7zip
      ripgrep
      jq
      yq-go
      eza
      fzf
      mtr
      iperf3
      dnsutils
      ldns
      aria2
      socat
      nmap
      ipcalc
      cowsay
      fortune
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg
      nix-output-monitor
      glow
      btop
      iotop
      iftop
      strace
      ltrace
      lsof
      sysstat
      lm_sensors
      ethtool
      pciutils
      usbutils
      go
      zig
      bun
      cmake
      clang
      rustup
      rustup-toolchain-install-master
      nodejs_24
      python3
      corepack
      obs-studio
      obs-studio-plugins.wlrobs
      obs-studio-plugins.obs-pipewire-audio-capture
      zls
      gopls
      pyright
      marksman
      lua-language-server
      golangci-lint
      golangci-lint-langserver
      vscode-langservers-extracted
      typescript-language-server
      tailwindcss-language-server
      svelte-language-server
      markdownlint-cli
      nixfmt-classic
      alejandra
      nixd
      nil
      grimblast
      grim
      slurp
      whitesur-cursors
      colloid-gtk-theme
      kanagawa-gtk-theme
      zuki-themes
      graphite-gtk-theme
      papirus-icon-theme
      nwg-look
      inputs.zen-browser.packages."${system}".default
      slack
      xdg-desktop-portal-gtk
      telegram-desktop
      beam28Packages.elixir
      beam28Packages.elixir-ls
      yazi
      file
      unzip
      ffmpegthumbnailer
      poppler_utils
      zoxide
      fzf
      home-manager
    ];
  };

  programs.zen-browser.enable = true;
}
