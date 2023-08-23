{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.vscode-server;
  jsonFormat = pkgs.formats.json { };
  userSettings = jsonFormat.generate cfg.userSettings;
in
{
  options.mayniklas.programs.vscode-server = {
    enable = mkEnableOption "vscode-server";

    userSettings = mkOption {
      type = jsonFormat.type;
      default = {
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.fontFamily" = "source code pro";
        "[go]" = {
          "editor.defaultFormatter" = "golang.go";
        };
        "[nix]" = {
          "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt";
        };
        "nix.enableLanguageServer" = "true";
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
      };
      description = ''
        JSON string with vscode user settings
      '';
    };
  };

  config = mkIf cfg.enable {

    home.file = {
      # ~/.vscode-server/data/Machine/settings.json
      "vscode-user-settings" = {
        target = ".vscode-server/data/Machine/settings.json";
        source = userSettings;
        # text = ''
        #   ${userSettings}
        # '';
      };

    };

  };
}



