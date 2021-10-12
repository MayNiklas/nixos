{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.iperf;
in {

  options.mayniklas.iperf = { enable = mkEnableOption "activate iperf"; };

  config = mkIf cfg.enable {

    services.iperf3 = {
      enable = true;
      openFirewall = false;
      port = 5201;
    };
    
    networking.firewall = { interfaces.wg0.allowedTCPPorts = [ 5201 ]; };

  };
}
