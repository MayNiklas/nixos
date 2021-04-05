{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.grub;
in {

  options.mayniklas.grub = { enable = mkEnableOption "activate grub"; };

  config = mkIf cfg.enable {

    boot = {
      loader = {
        grub = {
          enable = true;
          version = 2;
          device = "nodev";
          efiSupport = true;
        };
        efi.canTouchEfiVariables = true;
      };
      cleanTmpDir = true;
    };
  };
}
