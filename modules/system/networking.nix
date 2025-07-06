{ pkgs, ... }:
{
  networking = {
    hostName = "nix";
    wireless = {
      enable = false;
    };
    networkmanager = {
      enable = true;
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    firewall = {
      enable = true;
      # allowedUDPPorts = [ ... ];
      # allowedTCPPorts = [ ... ];
    };
  };
}
