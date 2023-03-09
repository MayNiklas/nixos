{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.minio;
in
{

  options.mayniklas.minio = {
    enable = mkEnableOption "activate minio";
    load-ballancer = mkEnableOption "activate minio load ballancer";
    storage-target = mkEnableOption "activate minio storage target";

  };

  config = mkIf cfg.enable {

    # services.minio = mkIf cfg.storage-target {
    #   enable = true;
    #   listenAddress = "127.0.0.1:9000";
    #   consoleAddress = "127.0.0.1:9001";
    #   region = "eu-central-1";
    #   rootCredentialsFile = config.sops.secrets."minio/env".path;
    # };

    # systemd.services.minio = mkIf cfg.storage-target {
    #   environment = {
    #     MINIO_SERVER_URL = "https://s3.lounge.rocks";
    #     MINIO_BROWSER_REDIRECT_URL = "https://minio.s3.lounge.rocks";
    #   };
    # };

    networking = {
      firewall.checkReversePath = "loose";
      nameservers = [ "100.100.100.100" ];
    };

    # we use tailscale for communication between the reverse proxy & storage targets
    # tailscale up to login
    services.tailscale = {
      enable = true;
      interfaceName = "tailscale0";
    };

    # we want to deploy from our nginx system -> dev purposes
    users.users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChYWn2XCh9VYr6DXibX9rLbnikafhZyviDvwfiKQ1m1WNy9sLkd5s3iK4kc1QFeN9y3Kw5oIeok1c6OmG9YsGJVwt/TooobFQiN0gzeBi5rEiFzBcaCPEbooL+n7Yu9/tq7j4bp28eqfzxtJquEQnXan/X1GOSusXcMI2YyCkQW29dX1YwDnftS9MR5KYky795yEwSa0VjpRm84RfzFN4bbS5sRKvWokODGh7hVF6wGXVrm2slnClRlvhOuLUvrKD2svCxH1mc0HW5CIuVK+1dDLlnNHy8Yhbr+iT+CMFRbBreIFK4htDYwRcxzOBmejZMRB7DfvKlkAl4Eca9/H7SrP/bALsP6PQdHqoCIfUhM/XQqRdmBw3hHsyIDqxIPMLqwCqSgyoRUFH/gBtla1AE1LTmV6TOpFFeDQ3DkGrwYyllJO+0qd/u9VcbDYm441K69nUsoXmURULCfKg+dCPly3Yf6aig4hXY6S7FQidvZpd2N8o9RQujoi0Osn8Lve0= nik@minio-hetzner-1"
        ];
      };
    };

  };
}
