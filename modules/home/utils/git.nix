{pkgs, ...}: {
  programs.git = {
    enable = true;

    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      df = "diff";
      dc = "diff --cached";

      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      last = "log -1 HEAD";

      amend = "commit --amend";
      unstage = "reset HEAD --";
      undo = "reset HEAD~1";
      wip = "commit -a -m 'WIP'";
      wipe = "!git add -A && git commit -m 'WIP' && git reset HEAD~1";

      up = "pull --rebase";
      sync = "!git pull --rebase && git push";

      spush = "stash push";
      spop = "stash pop";
      sshow = "stash show -p";

      ignored = "!git ls-files -v | grep '^[[:lower:]]'";
      untracked = "ls-files --others --exclude-standard";
      branches = "branch -a";
      bdelmerged = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";
      ss = "status -sb";
      current = "rev-parse --abbrev-ref HEAD";
      publish = "!git push -u origin $(git current)";
      ri = "rebase -i";
      resetmain = "!git fetch origin && git reset --hard origin/main";
      who = "!git config user.name && git config user.email";
    };

    extraConfig = {
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = true;
      };
    };
  };
}
