{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    baseIndex = 1;
    clock24 = false;
    keyMode = "vi";
    mouse = true;
    newSession = false;
    terminal = "screen-256color";
    historyLimit = 9999;

    prefix = "C-Space";

    extraConfig = builtins.readFile ../../../extras/tmux/tmux.conf;

    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '30'
        '';
      }
      {
        plugin = tmuxPlugins.sensible;
        extraConfig = "set -g @plugin 'tmux-plugins/tmux-sensible'";
      }
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
        extraConfig = "set -g @plugin 'christoomey/vim-tmux-navigator'";
      }
    ];
  };
}
