{ self, ... }: {

  mayniklas = {
    minio = {
      enable = true;
      storage-target = true;
    };
    cloud.hetzner-x86 = {
      enable = true;
      interface = "ens3";
      ipv6_address = "2a01:4f8:1c1c:1adb::";
    };
    server = {
      enable = true;
      home-manager = true;
    };
  };

  mayniklas = {
    locale.enable = true;
    nix-common = { enable = true; };
    openssh.enable = true;
    zsh.enable = true;
  };

  networking = {
    hostName = "minio-1";
  };

  system.stateVersion = "22.05";

}
