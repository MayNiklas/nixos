# nix build .#netcup-x86-image
# nix build 'github:MayNiklas/nixos'#netcup-x86-image
{ self, ... }: {

  imports = [
    ../../modules/cloud-provider
    ../../modules/user
    ../../modules/locale
    ../../modules/nix-common
    ../../modules/openssh
    ../../modules/zsh
  ];

  mayniklas = {
    cloud.netcup-x86.enable = true;
    user = {
      nik.enable = true;
      root.enable = true;
    };
    locale.enable = true;
    nix-common = { enable = true; };
    openssh.enable = true;
    zsh.enable = true;
  };

  networking = {
    hostName = "netcup-x86";
    # interfaces.ens3 = {
    #   ipv6.addresses = [{
    #     address = "2a01:4f8:c0c:6600::";
    #     prefixLength = 64;
    #   }];
    # };
  };

  system.stateVersion = "22.05";

}
