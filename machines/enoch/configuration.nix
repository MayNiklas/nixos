{ self, ... }: {

  imports = [ ../../users/marek.nix ../../users/nik.nix ../../users/root.nix ];

  mayniklas = {
    fonts.enable = true;
    locale.enable = true;
    kde.enable = true;
    nix-common.enable = true;
    openssh.enable = true;
    zsh.enable = true;
    vmware-guest.enable = true;
  };

  environment.systemPackages =
    with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [
      bash-completion
      git
      nixfmt
      wget
    ];

  home-manager.users.marek = {
    imports = [
      ./marek.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
    ];
  };

  home-manager.users.nik = {
    imports = [
      ../../home-manager/home-server.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
    ];
  };

  networking.hostName = "enoch";

  system.stateVersion = "20.09";

}
