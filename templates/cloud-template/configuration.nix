{ self, ... }: {

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
    kvm-guest.enable = true;
  };

  networking.hostName = "cloud-template";

  system.stateVersion = "20.09";

}
