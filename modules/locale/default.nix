{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.locale;
in
{

  options.mayniklas.locale = { enable = mkEnableOption "activate locale"; };

  config = mkIf cfg.enable {

    # Set your time zone.
    time = {
      timeZone = "Europe/Berlin";
      hardwareClockInLocalTime = true;
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "de";
    };

  };
}
