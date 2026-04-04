{ lib, config, vscode-server, nixos-vscode-claude, ... }:
with lib;
let
  cfg = config.mayniklas.services.nixos-vscode-claude;
in
{
  imports = [
    vscode-server.nixosModules.home
    nixos-vscode-claude.homeModules.default
  ];

  options.mayniklas.services.nixos-vscode-claude.enable = mkEnableOption "enable VS Code Server and nixos-vscode-claude";

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
    services.nixos-vscode-claude.enable = true;
  };
}
