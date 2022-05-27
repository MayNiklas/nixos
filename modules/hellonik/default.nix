{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.services.hellonik;
in
{
  options.mayniklas.services.hellonik = {
    enable = mkEnableOption "hellonik service";
    greeter = mkOption {
      type = types.str;
      default = "nik";
      example = "world";
      description = "A very friendly service that greets nik";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hellonik = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart =
        "${pkgs.hello}/bin/hello -g'Hello, ${escapeShellArg cfg.greeter}!'";
    };
  };
}
