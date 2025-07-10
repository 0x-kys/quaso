{
  pkgs,
  inputs,
  ...
}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default = {
      userSettings = {};
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
      ];
    };
  };
}
