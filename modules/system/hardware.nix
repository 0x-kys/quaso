{pkgs, ...}: {
  hardware = {
    cpu = {
      intel = {
        updateMicrocode = true; # Ensures Intel CPU microcode updates for stability/security
      };
    };
    graphics = {
      enable = true; # Enables graphics support
      enable32Bit = true; # Enables 32-bit support (useful for some apps/games)
      extraPackages = with pkgs; [
        intel-media-driver # Modern Intel VAAPI driver for video acceleration (Skylake and newer, but works with Haswell too)
        libva-intel # Legacy VAAPI support for Intel GPUs (ensures compatibility with Haswell)
        libvdpau-va-gl # VDPAU to VAAPI bridge for broader compatibility
      ];
      extraPackages32 = with pkgs; [
        intel-media-driver # 32-bit version for Intel video acceleration
        libva-intel # 32-bit legacy Intel VAAPI
        libvdpau-va-gl # 32-bit VDPAU bridge
      ];
    };
  };
}
