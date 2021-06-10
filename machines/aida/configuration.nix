{ self, ... }: {

  mayniklas = {
    server = {
      enable = true;
      homeConfig = { imports = [ ../../home-manager/home-server.nix ]; };
    };
    vmware-guest.enable = true;
  };

  networking.hostName = "aida";

  system.stateVersion = "20.09";

}
