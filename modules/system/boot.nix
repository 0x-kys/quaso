{pkgs, ...}: {
  boot = {
    resumeDevice = "/dev/disk/by-uuid/ad7e4cc1-4366-40f7-8c21-2428bed2b43e";
    kernelParams = [
      "amdgpu.dc=1"
      "mem_sleep_default=deep"
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
