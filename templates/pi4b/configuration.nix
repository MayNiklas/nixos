{ self, ... }: {

  mayniklas = {
    pi4b.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
  };

  networking = {
    hostName = "pi4b";
    networkmanager = { enable = true; };
  };

  system.stateVersion = "21.03";

}
