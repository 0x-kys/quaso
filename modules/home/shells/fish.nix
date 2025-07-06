{pkgs, ...}: {
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };

      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    interactiveShellInit = ''
      set fish_greeting
    '';
    shellInit = ''
      set -gx ANDROID_HOME $HOME/Android/Sdk
      set -gx PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $PATH
    '';
    shellInitLast = ''
      starship init fish | source
    '';
  };
}
