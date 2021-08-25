{ self, ... }: {
  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
    nix-common = { disable-cache = false; };
    hosts = { enable = true; };
  };

  boot.cleanTmpDir = true;
  networking.hostName = "arm-server";
}
