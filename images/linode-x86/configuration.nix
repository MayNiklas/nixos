# nix build .#linode-x86-image
# nix build 'github:MayNiklas/nixos'#linode-x86-image
{ self, ... }: {

  imports = [
    ../../modules/cloud-provider
    ../../modules/user
    ../../modules/locale
    ../../modules/openssh
    ../../modules/zsh
  ];

  mayniklas = {
    cloud.linode-x86.enable = true;
    user = {
      nik.enable = true;
      root.enable = true;
    };
    locale.enable = true;
    openssh.enable = true;
    zsh.enable = true;
  };

  networking = {
    hostName = "linode-x86";
  };

  system.stateVersion = "22.05";

}
