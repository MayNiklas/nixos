{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.chromium;
in {
  options.mayniklas.programs.chromium.enable = mkEnableOption "enable chromium";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password X
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
      ];
    };
  };
}
