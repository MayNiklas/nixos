# 5.252.224.139
# 2a03:4000:40:1c0::/64
# nix run github:numtide/nixos-anywhere -- --flake .#netcup-test root@<IP>

# nix run .\#lollypops -- netcup-test
{ self, lib, ... }: {

  mayniklas.defaults.CISkip = true;

  mayniklas = {
    cloud-provider-default.netcup = {
      enable = true;
      ipv6_address = "2a03:4000:40:1c0:94d4:8eff:fea9:2fa6";
    };
    server = {
      enable = true;
      home-manager = true;
    };
  };

  lollypops.deployment = {
    local-evaluation = true;
    ssh = { user = "root"; host = "5.252.224.139"; };
  };

  networking.hostName = "netcup-test";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "20.09";

}
