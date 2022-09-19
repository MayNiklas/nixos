{ self, ... }: {

  mayniklas = {
    cloud.pve-x86.enable = true;
    hosts = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
    nginx.enable = true;
  };

  services.nginx = {
    virtualHosts = {
      "git.lounge.rocks" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = { proxyPass = "http://127.0.0.1:3000"; };
      };
    };
  };

  services.gitea = {
    enable = true;
    appName = "A personal git server";
    cookieSecure = true;
    database.user = "git";
    disableRegistration = true;
    domain = "git.lounge.rocks";
    dump.enable = false;
    dump.interval = "weekly";
    httpAddress = "127.0.0.1";
    httpPort = 3000;
    rootUrl = "https://git.lounge.rocks/";
    lfs.enable = true;
    settings = {
      "repository" = {
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
      };
      "repository.upload" = {
        FILE_MAX_SIZE = "50";
        MAX_FILES = "20";
      };
      "git.timeout" = {
        DEFAUlT = "360";
        MIGRATE = "600";
        MIRROR = "300";
        CLONE = "300";
        PULL = "300";
        GC = "60";
      };
      "service.explore" = {
        REQUIRE_SIGNIN_VIEW = true;
        DISABLE_USERS_PAGE = true;
      };
      other = {
        SHOW_FOOTER_BRANDING = false;
        SHOW_FOOTER_VERSION = true;
        SHOW_FOOTER_TEMPLATE_LOAD_TIME = true;
      };
    };
    ssh = {
      clonePort = 22;
      enable = true;
    };
    user = "git";
  };

  users.users = {
    git = {
      description = "Gitea Service";
      home = "/var/lib/gitea";
      useDefaultShell = true;
      group = "gitea";
      isSystemUser = true;
    };
  };

  users.groups.git = { };

  networking = {
    hostName = "simmons";
    firewall = { allowedTCPPorts = [ 80 443 9100 9115 ]; };
  };

  system.stateVersion = "20.09";

}
