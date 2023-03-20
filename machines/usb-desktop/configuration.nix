{ self, pkgs, lib, config, cachix, ... }: {

  mayniklas = {
    user = {
      nik.enable = true;
      root.enable = true;
    };
    locale.enable = true;
    openssh.enable = true;
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
    nvidia = {
      enable = true;
    };
    server = {
      enable = true;
      home-manager = true;
    };
    sway.enable = true;
    zsh.enable = true;
  };

  home-manager.users.nik = {
    home.packages =
      let
        cachix_package = cachix.packages.${pkgs.system}.cachix;
      in
      with pkgs; [
        cachix_package

        firefox
        sublime4
      ];
    # TODO: fix VSCode with sway on NVIDIA
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [ ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  boot = {
    growPartition = true;
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "uas" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking = {
    hostName = "usb-desktop";
    useDHCP = lib.mkDefault true;
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "22.05";

}
