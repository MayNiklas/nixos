{ self, ... }: {

  mayniklas = {
    octoprint.enable = true;
    pi4b.enable = true;
    server = {
      enable = true;
      homeConfig = { imports = [ ../../home-manager/home-server.nix ]; };
    };
    system = "aarch64-linux";
    system-config = "aarch64-unknown-linux-gnu";
  };

  networking = {
    hostName = "pi4b"; # Define your hostname.
    networkmanager = { enable = true; };
    wireless.enable = false;
  };

  system.stateVersion = "21.03";

}
