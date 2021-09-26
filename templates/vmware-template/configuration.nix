{ self, ... }: {

  # to build disk image:
  # nix build .#nixosConfigurations.vmware-template.config.system.build.vmwareImage

  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    server = {
      enable = true;
      home-manager = true;
    };
    vmware-guest.enable = true;
  };

  networking.hostName = "vmware-template";

  system.stateVersion = "20.09";

}
