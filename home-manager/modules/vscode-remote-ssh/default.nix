{
  lib,
  config,
  vscode-server,
  nixos-vscode-claude,
  ...
}:
with lib;
let
  cfg = config.mayniklas.services.vscode-remote-ssh;
in
{
  imports = [
    vscode-server.nixosModules.home
    nixos-vscode-claude.homeModules.default
  ];

  options.mayniklas.services.vscode-remote-ssh = {
    enable = mkEnableOption "enable VS Code Server";
    claude = mkEnableOption "enable Claude fix for VS Code Server";
  };

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
    services.nixos-vscode-claude.enable = mkIf cfg.claude true;
  };
}
