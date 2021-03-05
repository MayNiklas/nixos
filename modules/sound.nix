{ config, pkgs, lib, ... }: {

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  environment.systemPackages = with pkgs; [ pavucontrol ];

  users.extraUsers.${config.mainUser}.extraGroups = [ "audio" ];

}
