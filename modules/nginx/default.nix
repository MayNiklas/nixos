{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.nginx;
in {

  options.mayniklas.nginx = { enable = mkEnableOption "activate nginx"; };

  config = mkIf cfg.enable {

    security.acme.email = "acme@niklas-steffen.de";
    security.acme.acceptTerms = true;

    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "128m";

      commonHttpConfig = ''
        server_names_hash_bucket_size 128;
      '';
    };

  };
}
