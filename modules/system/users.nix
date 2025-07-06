{pkgs, ...}: {
  users = {
    users = {
      syk = {
        isNormalUser = true;
        description = "syk";
        extraGroups = ["networkmanager" "wheel" "storage" "plugdev" "adbusers" "video" "audio"];
        shell = pkgs.fish;
      };
    };
  };
}
