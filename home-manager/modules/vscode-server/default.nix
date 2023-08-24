{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.vscode-server;
in
{
  options.mayniklas.programs.vscode-server = {
    enable = mkEnableOption "vscode-server";
    userSettings = mkOption {
      type = types.attrs;
      default = {
        # jnoortheen.nix-ide
        "nix" = {
          "enableLanguageServer" = true;
          "serverPath" = "${pkgs.nil}/bin/nil";
          "serverSettings" = {
            "nil" = {
              "formatting" = { "command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ]; };
            };
          };
        };
      };
      description = ''
        JSON string with vscode user settings
      '';
    };
    extensions = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.vscode-extensions.jnoortheen.nix-ide ];
      example = literalExpression "[ pkgs.vscode-extensions.bbenoist.nix ]";
      description = ''
        The extensions Visual Studio Code should be started with.
      '';
    };
  };

  config = mkIf cfg.enable {

    home.file =
      let
        extensionPath = ".vscode-server/extensions";
        extensionJson = pkgs.vscode-utils.toExtensionJson cfg.extensions;
        extensionJsonFile = pkgs.writeTextFile {
          name = "extensions-json";
          destination = "/share/vscode/extensions/extensions.json";
          text = extensionJson;
        };
      in
      {

        "vscode-user-settings" = {
          target = ".vscode-server/data/Machine/settings.json";
          text = "${builtins.toJSON cfg.userSettings}";
        };

        # "${extensionPath}".source =
        #   let
        #     combinedExtensionsDrv = pkgs.buildEnv {
        #       name = "vscode-extensions";
        #       paths = cfg.extensions ++ extensionJsonFile;
        #     };
        #   in
        #   "${combinedExtensionsDrv}/${subDir}";

        # "jnoortheen.nix-ide" = let extension-package = pkgs.vscode-extensions.jnoortheen.nix-ide; in {
        #   target = "${extensionPath}/${extension-package.name}";
        #   source = extension-package;
        #   onChange = ''
        #     $DRY_RUN_CMD rm $VERBOSE_ARG -f ${extensionPath}/{extensions.json,.init-default-profile-extensions}
        #   '';
        # };

      };

  };
}

