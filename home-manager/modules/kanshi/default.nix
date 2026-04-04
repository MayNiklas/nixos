{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.mayniklas.programs.kanshi;
in
{
  options.mayniklas.programs.kanshi = {
    enable = mkEnableOption "enable kanshi";
  };

  config = mkIf cfg.enable {

    services.kanshi = {
      enable = true;
      settings = [
        {
          # Fallback: just use whatever is connected
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        }
      ];
    };

  };
}
