{ self, ... }: {
  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    server = {
      enable = true;
      home-manager = true;
    };
    nix-common = { disable-cache = false; };
    hosts = { enable = true; };
  };

  boot.cleanTmpDir = true;
  networking.hostName = "arm-server";
}
