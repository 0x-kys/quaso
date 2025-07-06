{pkgs, ...}: {
  boot = {
    kernelParams = [
      "amdgpu.dc=1"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 7;
      };
      efi = {canTouchEfiVariables = true;};
    };
  };
}
