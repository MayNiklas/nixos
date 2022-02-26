{ config, lib, pkgs, ... }: {
  services.cron = {
    enable = true;
    systemCronJobs =
      [ "*/5 * * * *      root    ${pkgs.curl}/bin/curl $(cat /var/src/secrets/dynv6/url.txt)" ];
  };
}
