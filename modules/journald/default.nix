{ config, lib, ... }:
{
  options.mayniklas.journald.enable = lib.mkEnableOption "journal retention limits";

  config = lib.mkIf config.mayniklas.journald.enable {
    services.journald.settings.Journal = {
      SystemMaxUse = lib.mkDefault "1G";
      SystemKeepFree = lib.mkDefault "4G";
      MaxRetentionSec = lib.mkDefault "30day";
    };
  };
}
