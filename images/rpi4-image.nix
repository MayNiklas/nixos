# nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=images/rpi4-image.nix

{ pkgs, lib, ... }: {
  nixpkgs.localSystem.system = "aarch64-linux";
  imports = [ <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix> ];

  environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

  networking = {
    hostName = "pi4b";
    networkmanager = { enable = true; };
  };

  # Set your time zone.
  time = { timeZone = "Europe/Berlin"; };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
    # Save space by hardlinking store files
    autoOptimiseStore = true;
    # Clean up old generations after 30 days
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Users allowed to run nix
    allowedUsers = [ "root" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    startWhenNeeded = true;
    challengeResponseAuthentication = false;

  };

  boot = {
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      # Some gui programs need this
      "cma=128M"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
      })
    ];
  };

}
