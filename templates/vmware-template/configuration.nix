{ self, ... }: {

  # to build disk image:
  # nix build .#nixosConfigurations.vmware-template.config.system.build.vmwareImage

  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay ]; }
        ];
      };
    };
    vmware-guest.enable = true;
  };

  networking.hostName = "vmware-template";

  system.stateVersion = "20.09";

}
