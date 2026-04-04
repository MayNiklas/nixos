{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.wofi;
  c = config.pinpox.colors;
in
{
  options.mayniklas.programs.wofi.enable = mkEnableOption "enable wofi";

  config = mkIf cfg.enable {

    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.wofi.enable
    programs.wofi = {
      enable = true;
      settings = {
        location = "bottom-right";
        allow_markup = true;
        width = 500;
      };
      style = ''
        window {
          font-family: "Berkeley Mono";
          font-size: 12px;
          background-color: #${c.Black};
          color: #${c.White};
          border: 2px solid #${c.Blue};
          border-radius: 3px;
        }

        #input {
          background-color: #${c.BrightBlack};
          color: #${c.White};
          border: none;
          border-radius: 3px;
          padding: 8px 12px;
          margin: 5px;
        }

        #outer-box {
          margin: 0;
          padding: 5px;
        }

        #scroll {
          margin: 0;
          padding: 0;
        }

        #entry {
          padding: 8px 12px;
          border-radius: 3px;
        }

        #entry:selected {
          background-color: #${c.Blue};
          color: #${c.Black};
        }
      '';
    };

  };
}
