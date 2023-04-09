{ lib, pkgs, config, nixified-ai, ... }:
with lib;
let cfg = config.mayniklas.invokeai;
in
{

  options.mayniklas.invokeai = {
    enable = mkEnableOption "activate invokeai";
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall for the invokeai port.";
    };
  };

  imports = [
    nixified-ai.nixosModules.invokeai-nvidia
  ];

  config = mkIf cfg.enable {

    services.invokeai = {
      enable = true;
      host = mkIf cfg.openFirewall "0.0.0.0";
      port = 9090;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9090 ];
    };

  };
}
