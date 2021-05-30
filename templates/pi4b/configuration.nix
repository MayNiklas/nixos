{ self, ... }: {

  mayniklas = {
    pi4b.enable = true;
    server = {
      enable = true;
      homeConfig = { imports = [ ../../home-manager/home-server.nix ]; };
    };
  };

  networking = {
    hostName = "pi4b";
    networkmanager = { enable = true; };
  };

  system.stateVersion = "21.03";

}
