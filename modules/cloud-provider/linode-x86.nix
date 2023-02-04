{ config, pkgs, lib, modulesPath, ... }:

with lib;
let cfg = config.mayniklas.cloud.linode-x86;

in
{

  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  options.mayniklas.cloud.linode-x86 = {
    enable = mkEnableOption "activate hetzner-x86";
  };

  config = mkIf cfg.enable {

    services.qemuGuest.enable = true;

    # Filesystem
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.timeout = 15;

    # Kernel and GRUB options required to enable LISH console
    boot.kernelParams = [ "console=ttyS0,19200n8" ];
    boot.loader.grub.extraConfig = ''
      serial --speed=1900 --unit=0 --word=8 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial
    '';

    boot.initrd.availableKernelModules = [ "virtio_pci" "ahci" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.eth0.useDHCP = true;
    networking.usePredictableInterfaceNames = false;

    # Linode requires that IPv6 privacy extension temporary addresses are disabled
    networking.interfaces.eth0.tempAddress = "disabled";


    # These tools are included on most Linode images, and are frequently used by Linode
    # support when troubleshooting networking and host level issues.
    environment.systemPackages = with pkgs; [
      inetutils
      mtr
      sysstat
    ];

  };
}
