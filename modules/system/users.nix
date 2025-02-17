{pkgs, ...}: {
  users = {
    users = {
      syk = {
        isNormalUser = true;
        description = "syk";
        extraGroups = ["networkmanager" "wheel" "storage" "plugdev" "video" "audio"];
        shell = pkgs.nushell;
      };
    };
  };
}
