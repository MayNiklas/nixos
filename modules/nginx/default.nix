{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.nginx;
in
{

  options.mayniklas.nginx = {
    enable = mkEnableOption "activate nginx";
    email = mkOption {
      type = types.str;
      default = "acme@niklas-steffen.de";
      description = ''
        Documentation placeholder
      '';
    };
  };

  config = mkIf cfg.enable {

    security.acme.defaults.email = "${cfg.email}";
    security.acme.acceptTerms = true;

    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "128m";
      recommendedProxySettings = true;

      commonHttpConfig = ''
        server_names_hash_bucket_size 128;
      '';
    };

  };
}
