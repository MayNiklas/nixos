{ self, ... }: {

  mayniklas = {
    server = {
      enable = true;
      home-manager = true;
    };
    matrix = {
      enable = true;
      host = "matrix.lounge.rocks";
    };
    kvm-guest.enable = true;
  };

  networking.hostName = "the-bus";

  system.stateVersion = "20.09";

}
