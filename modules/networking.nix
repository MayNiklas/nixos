{ config, pkgs, lib, ... }: {

  networking = {

    # Define the DNS servers
    nameservers = [ "192.168.5.10" "192.168.5.1" "1.1.1.1" ];

    # Enable networkmanager
    networkmanager.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
  };
  users.extraUsers.${config.mainUser}.extraGroups = [ "networkmanager" ];
}
