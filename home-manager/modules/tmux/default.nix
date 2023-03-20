{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.tmux;
in
{
  options.mayniklas.programs.tmux.enable = mkEnableOption "enable tmux";

  config = mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      # not available in 22.11
      # mouse = true;
    };

  };

}
