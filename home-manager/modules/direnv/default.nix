{ pkgs, lib, config, ... }:
with lib;
let cfg = config.mayniklas.programs.direnv;
in
{

  options.mayniklas.programs.direnv = {
    enable = mkEnableOption "activate direnv";
  };

  config = mkIf cfg.enable {

    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      git = { ignores = [ ".direnv/" ]; };
      vscode = { extensions = with pkgs.vscode-extensions; [ mkhl.direnv ]; };
    };

  };

}
