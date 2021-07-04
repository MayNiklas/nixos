{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.var;
in {

  options.mayniklas.var.mainUser = lib.mkOption {
    type = lib.types.str;
    default = "nik";
    description = ''
      Documentation placeholder
    '';
  };

  options.mayniklas.var.nasIP = lib.mkOption {
    type = lib.types.str;
    default = "192.168.5.10";
    description = ''
      Documentation placeholder
    '';
  };

  options.mayniklas.system = lib.mkOption {
    type = lib.types.str;
    default = "x86_64-linux";
    description = ''
      Documentation placeholder
    '';
  };

  options.mayniklas.system-config = lib.mkOption {
    type = lib.types.str;
    default = "x86_64-unknown-linux-gnu";
    description = ''
      Documentation placeholder
    '';
  };

}
