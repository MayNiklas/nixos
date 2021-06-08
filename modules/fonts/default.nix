{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.fonts;
in {

  options.mayniklas.fonts = { enable = mkEnableOption "activate fonts"; };

  config = mkIf cfg.enable {

    fontDir.enable = true;

    fonts.fonts = with pkgs; [
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      source-sans-pro
      source-serif-pro
      noto-fonts-emoji
      corefonts
      recursive
      ttf_bitstream_vera
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Recursive Sans Casual Static Medium" ];
        sansSerif = [ "Recursive Sans Linear Static Medium" ];
        monospace = [ "Recursive Mono Linear Static" ];
        emoji = [ "Noto Color Emoji" ];
      };

    };
  };
}