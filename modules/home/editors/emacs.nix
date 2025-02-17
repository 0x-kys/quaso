{pkgs, ...}: {
  programs.emacs = {
    enable = false;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.use-package
      epkgs.evil
      epkgs.evil-collection
      epkgs.general
      epkgs.doom-themes
      epkgs.flycheck
      epkgs.lsp-ui
      epkgs.company
      epkgs.projectile
      epkgs.ivy
      epkgs.which-key
      epkgs.highlight-indent-guides
      epkgs.nix-mode
      epkgs.web-mode
      epkgs.typescript-mode
      epkgs.svelte-mode
      epkgs.go-mode
      epkgs.zig-mode
      epkgs.rust-mode
      epkgs.page-break-lines
      epkgs.dashboard
    ];
    extraConfig = builtins.readFile ../../../extras/emacs/config.el;
  };
}
