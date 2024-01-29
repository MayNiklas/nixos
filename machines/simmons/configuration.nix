{ self, lib, pkgs, ... }: {

  mayniklas = {
    cloud.pve-x86.enable = true;
    hosts = { enable = true; };
    kernel = { enable = true; };
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
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig = ''
            client_max_body_size 256M;
          '';
        };
      };
    };
  };

  services.gitea = {
    enable = true;
    appName = "A personal git server";
    database.user = "git";
    # dump.enable = true;
    # dump.interval = "weekly";
    lfs.enable = true;
    user = "git";

    settings = {
      server = {
        ROOT_URL = "https://git.lounge.rocks/";
        DOMAIN = "git.lounge.rocks";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        SSH_PORT = 22;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      session = {
        COOKIE_SECURE = true;
      };
      "repository" = {
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
      };
      "repository.upload" = {
        FILE_MAX_SIZE = "50";
        MAX_FILES = "20";
      };
      "git.timeout" = {
        DEFAUlT = "3600";
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
      "markup.latex" =
        let
          # have to check if that makes it better
          # https://github.com/go-gitea/gitea/issues/17635
          template-config = builtins.toFile "basic.html" (
            ''
              $for(include-before)$
              $include-before$
              $endfor$
              $if(title)$
              $title$
              $if(subtitle)$
              $subtitle$
              $endif$
              $for(author)$
              $author$
              $endfor$
              $if(date)$
              $date$
              $endif$
              $endif$
              $if(toc)$
              $idprefix$TOC
              $if(toc-title)$
              $toc-title$
              $endif$
              $table-of-contents$
              $endif$
              $body$
              $for(include-after)$
              $include-after$
              $endfor$
            ''
          );
        in
        {
          ENABLED = true;
          FILE_EXTENSIONS = ".tex,.latex";
          RENDER_COMMAND = "timeout 30s ${pkgs.pandoc}/bin/pandoc --pdf-engine=${pkgs.texlive.combined.scheme-full}/bin/pdflatex -f latex -t html --embed-resources --standalone --template ${template-config}";
        };
    };

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

  lollypops.deployment = {
    local-evaluation = false;
    ssh = { user = "root"; host = "192.168.20.10"; };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "20.09";

}
