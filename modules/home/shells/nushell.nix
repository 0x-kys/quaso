{pkgs, ...}: {
  programs.nushell = {
    enable = true;
    extraConfig = builtins.readFile ../../../extras/nushell/config.nu;
    shellAliases = {
      glog = "git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'";
      ff = "fastfetch -c examples/19.jsonc";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
