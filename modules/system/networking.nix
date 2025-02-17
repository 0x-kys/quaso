{pkgs, ...}: {
  networking = {
    hostName = "nix";
    wireless = {enable = false;};
    networkmanager = {enable = true;};
    firewall = {
      enable = true;
      # allowedUDPPorts = [ ... ];
      # allowedTCPPorts = [ ... ];
    };
  };
}
