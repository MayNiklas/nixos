{ self, ... }: {

  mayniklas = {
    cloud.linode-x86.enable = true;
    user = {
      nik.enable = true;
      root.enable = true;
    };
    server = {
      enable = true;
      home-manager = true;
    };
    locale.enable = true;
    openssh.enable = true;
    zsh.enable = true;
  };

  networking = {
    hostName = "whisper-linode";
  };

  system.stateVersion = "22.05";

}
