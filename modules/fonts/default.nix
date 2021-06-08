{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.fonts;
in {

  options.mayniklas.fonts = { enable = mkEnableOption "activate fonts"; };

  config = mkIf cfg.enable {

    fonts.fonts = with pkgs; [
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      ttf_bitstream_vera
    ];

  };
}
