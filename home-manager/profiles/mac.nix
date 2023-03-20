{ config, pkgs, lib, ... }: {

  home.packages = with pkgs;[
    # my packages
    whisper_cli

    # nix tools
    nixpkgs-fmt

    # network tools
    iperf
    nmap
    speedtest-cli
    wakeonlan
    wireshark

    # devops tools
    ansible
    ansible-lint
    glances
    htop
    hugo
    terraform
    wget

    # dev tools
    asciinema
    go
    pre-commit
    rpiboot
    texlive.combined.scheme-full
  ];

  mayniklas.programs = {
    git.enable = true;
  };

  imports = [
    ../modules/git
  ];

  home = {
    username = "nik";
    homeDirectory = "/Users/nik";
  };

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
