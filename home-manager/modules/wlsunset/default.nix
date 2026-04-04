{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.mayniklas.programs.wlsunset;
in
{
  options.mayniklas.programs.wlsunset.enable = mkEnableOption "enable wlsunset";

  config = mkIf cfg.enable {

    services.wlsunset = {
      enable = true;
      # Approximate coordinates for Germany
      latitude = "51.0";
      longitude = "10.0";
    };

  };
}
