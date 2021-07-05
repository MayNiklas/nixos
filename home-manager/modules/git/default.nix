{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      ignores = [ "tags" "*.swp" ];

      extraConfig = { pull.rebase = false; };

      userEmail = "info@niklas-steffen.de";
      userName = "MayNiklas";
    };
  };
}
