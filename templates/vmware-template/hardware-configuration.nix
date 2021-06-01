{ modulesPath, ... }: {
  imports = [ (modulesPath + "/virtualisation/vmware-image.nix") ];
}
