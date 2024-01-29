{ pkgs, lib, config, ... }: {

  home-manager.users."${config.mayniklas.home-manager.username}" = {
    home.packages =
      with pkgs; [
        # https://github.com/ryantm/nixpkgs-update
        # nixpkgs-update.packages.${pkgs.system}.nixpkgs-update
      ];
  };

  mayniklas = {
    cloud.pve-x86.enable = true;
    hosts = { enable = true; };
    intel = { enable = true; };
    kernel = { enable = true; };
    plex = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
  };

  fileSystems."/mnt/deke" = {
    device = "//deke/public";
    options = [ "soft" "ro" "nounix" "dir_mode=0777" "file_mode=0777" ];
    fsType = "cifs";
  };

  fileSystems."/mnt/snowflake" = {
    device = "//snowflake/public";
    options = [ "soft" "ro" "nounix" "dir_mode=0777" "file_mode=0777" ];
    fsType = "cifs";
  };

  fileSystems."/mnt/plex-media" = {
    device = "ds1819.local:/volume1/plex-media";
    options = [ "nolock" "soft" "ro" ];
    fsType = "nfs";
  };

  fileSystems."/mnt/media" = {
    device = "ds1819.local:/volume1/media";
    options = [ "nolock" "soft" "ro" ];
    fsType = "nfs";
  };

  systemd.services.plex = {
    after = [
      "remote-fs.target"
      "mnt-media.mount"
      "mnt-plexx2dmedia.mount"
      "mnt-snowflake.mount"
      "mnt-deke.mount"
    ];
  };

  networking = {
    hostName = "aida";
    dhcpcd.enable = false;
    interfaces.enp6s18.ipv4.addresses = [{
      address = "192.168.5.20";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.5.1";
    nameservers = [ "192.168.5.1" "1.1.1.1" ];
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  lollypops.deployment = {
    local-evaluation = false;
    ssh = { user = "root"; host = "192.168.5.20"; };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "20.09";

}
