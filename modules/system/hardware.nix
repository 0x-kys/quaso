{pkgs, ...}: {
  hardware = {
    cpu = {amd = {updateMicrocode = true;};};
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [vaapiVdpau libvdpau-va-gl];
      extraPackages32 = with pkgs; [vaapiIntel vaapiVdpau libvdpau-va-gl];
    };
  };
}
