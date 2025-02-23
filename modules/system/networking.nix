{pkgs, ...}: {
  networking = {
    hostName = "nixbook"; # NOTE: update if needed
    wireless = {enable = false;};
    networkmanager = {enable = true;};
    firewall = {
      enable = true;
      # allowedUDPPorts = [ ... ];
      # allowedTCPPorts = [ ... ];
    };
  };
}
