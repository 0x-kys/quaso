if status is-interactive
          set fish_greeting
      end

      set -gx ANDROID_HOME $HOME/Android/Sdk
      set -gx PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $PATH

      starship init fish | source
