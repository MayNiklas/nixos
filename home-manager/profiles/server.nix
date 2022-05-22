{ config, pkgs, lib, ... }: {

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Install these packages for my user
  home.packages = with pkgs; [
    htop
    iperf3
    nixfmt
    unzip
    (pkgs.callPackage ../../packages/drone-gen { })
    (pkgs.callPackage ../../packages/vs-fix { })
  ];

  mayniklas = {
    programs = {
      git.enable = true;
      vim.enable = true;
      zsh.enable = true;
    };
  };

  # Imports
  imports = [ ../modules/git ../modules/vim ../modules/zsh ];

  # Include man-pages
  manual.manpages.enable = true;

  programs.command-not-found.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
