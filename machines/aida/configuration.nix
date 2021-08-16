{ self, ... }: {

  mayniklas = {
    plex = { enable = true; };
    hosts = { enable = true; };
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
    metrics = {
      node.enable = true;
      blackbox.enable = true;
    };
    vmware-guest.enable = true;
  };

  fileSystems."/mnt/deke" = {
    device = "//deke/public";
    options =
      [ "nolock" "soft" "ro" "nounix" "dir_mode=0777" "file_mode=0777" ];
    fsType = "cifs";
  };

  fileSystems."/mnt/snowflake" = {
    device = "//snowflake/public";
    options =
      [ "nolock" "soft" "ro" "nounix" "dir_mode=0777" "file_mode=0777" ];
    fsType = "cifs";
  };

  networking.hostName = "aida";

  system.stateVersion = "20.09";

}
