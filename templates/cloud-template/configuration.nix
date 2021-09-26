{ self, ... }: {

  mayniklas = {
    server = {
      enable = true;
      home-manager = true;
      };
    };
    kvm-guest.enable = true;
  };

  networking.hostName = "cloud-template";

  system.stateVersion = "20.09";

}
