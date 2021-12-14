{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.iperf;
in {

  options.mayniklas.iperf = {

    enable = mkEnableOption "activate iperf";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open the appropriate ports in the firewall for owncast.
      '';
    };

  };

  config = mkIf cfg.enable {

    services.iperf3 = {
      enable = true;
      openFirewall = false;
      port = 5201;
    };

    networking.firewall = {
      allowedTCPPorts = mkIf cfg.openFirewall [ 5201 ];
      interfaces = { wg0.allowedTCPPorts = [ 5201 ]; };
    };

  };
}
