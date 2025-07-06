{
  pkgs,
  config,
  ...
}: {
  hardware = {
    cpu = {
      amd = {
        updateMicrocode = true;
      };
    };
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
