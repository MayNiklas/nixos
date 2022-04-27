# to build disk image:
# nix build .#nixosConfigurations.vmware-template.config.system.build.vmwareImage
{ self, ... }: {

  imports = [ ./hardware-configuration.nix ];

  mayniklas = {
    server = {
      enable = true;
      home-manager = true;
    };
    vmware-guest.enable = true;
  };

  networking.hostName = "vmware-x86";

  system.stateVersion = "22.05";

}
