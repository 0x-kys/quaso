{pkgs, ...}: {
  boot = {
    # NOTE: Replace with your swap partition; use 'lsblk' to find it & use `sudo blkid /dev/swap/parition` to find UUID
    # resumeDevice = "/dev/disk/by-uuid/<UUID_HERE>";
    kernelParams = [
      "i915.enable_psr=1" # Enable Panel Self Refresh for power savings (Intel graphics)
      "i915.enable_fbc=1" # Enable Framebuffer Compression (Intel graphics, power efficiency)
      "mem_sleep_default=deep" # Keep this for deep sleep states (hibernation support)
      "acpi_backlight=vendor" # May help with backlight control on Intel MacBooks
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
