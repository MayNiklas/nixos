{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "de";
    xkbOptions = "eurosign:e";
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
        arandr
        xorg.xmodmap
        xorg.xdpyinfo
        pulsemixer
        alacritty
      ];
    };
  };
  nixpkgs = { config.allowUnfree = true; };
}
