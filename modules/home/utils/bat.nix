{pkgs, ...}: {
  programs.bat = {
    enable = true;
    package = pkgs.bat;
    config = {
      theme = "base16";
      pager = "less -FR";
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
      ];
    };
  };
}
