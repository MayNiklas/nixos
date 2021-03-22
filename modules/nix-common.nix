{ config, pkgs, ... }: {

  nixpkgs = { config.allowUnfree = true; };

  nix = {

    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';

    # Save space by hardlinking store files
    autoOptimiseStore = true;

    # Clean up old generations after 30 days
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Users allowed to run nix
    allowedUsers = [ "root" ];
  };
}
