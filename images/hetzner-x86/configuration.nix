# parted -s /dev/sda -- mklabel msdos
# parted /dev/sda -- mkpart primary 1MiB 100%
# mkfs.ext4 -L nixos /dev/sda1
# mount /dev/disk/by-label/nixos /mnt
# nix-shell -p nixFlakes -p git --run "nixos-install --flake 'github:MayNiklas/nixos'#hetzner-x86"
{ self, ... }: {

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    # server = {
    #   enable = true;
    #   home-manager = true;
    # };
  };

  ### remove lines once server module got enabled
  mayniklas = {
    locale.enable = true;
    nix-common = { enable = true; };
    openssh.enable = true;
    zsh.enable = true;
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXZFusz81OwV8tiQjhvUMaXu3D8YfB8c375k5pIbwLWBi6Ouzp9MvNO1dNldrI6r2cmeeJH5pbnwsnzlUrYyoP/mb1cYfC9KqejrPySor9407RFQyYd738fs9wS2Mpak8VcoGH1LX0RD+JrVrVvUd6VVnKdmXeuZsv3IXDiGMH7HN6WOVuE5Y7fgBUNWmKROInR28aWTJc1sLN5ad85Z1suKIFqVR2FIjce1HsOyq7AIuJqgp5GOz5R7z2d30iziCo+r8vonABqdmsFUUR4tXoWD6S0VR6bfK12KnJfg4hSGYkNb85VQwS1BFaVnk+Nx1rRmSwFLQiJfFxRmGF6paMmCNoZ5m5AloVgpgcmDbgWoYSiLebN+sE8wEk7hVoht3SowSKBjBT8BJwg+hqBEhAfL1IgRJZwivzBdb7OQ5K8l3JiZjoM4Xg2HAcEsWNpmpNK+l6tRvlv2L/dQPtoky712Yh7lpX5dI5sSNAdIVgvtker4+D1LWmcVkDCg9bvYKckPLL+zJpeqbgSp0UoUqPBrmDxFmcmMKC0mOEKrMMpwEsgZZAnzDznJvqEFOFHsXy4U2WPBywXN7geoeABbUDbmw8sgDTEzPnemqrHng8UbhuQ7HcWHUqZTqlg99U5XnDQrxw5UkORZ3d3m9fiAvsOfDaar6/qWS+6If69x3CmQ== macbook"
      ];
    };
    nik = {
      isNormalUser = true;
      home = "/home/nik";
      extraGroups = [ "wheel" ];
      shell = self.inputs.nixpkgs.legacyPackages.x86_64-linux.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXZFusz81OwV8tiQjhvUMaXu3D8YfB8c375k5pIbwLWBi6Ouzp9MvNO1dNldrI6r2cmeeJH5pbnwsnzlUrYyoP/mb1cYfC9KqejrPySor9407RFQyYd738fs9wS2Mpak8VcoGH1LX0RD+JrVrVvUd6VVnKdmXeuZsv3IXDiGMH7HN6WOVuE5Y7fgBUNWmKROInR28aWTJc1sLN5ad85Z1suKIFqVR2FIjce1HsOyq7AIuJqgp5GOz5R7z2d30iziCo+r8vonABqdmsFUUR4tXoWD6S0VR6bfK12KnJfg4hSGYkNb85VQwS1BFaVnk+Nx1rRmSwFLQiJfFxRmGF6paMmCNoZ5m5AloVgpgcmDbgWoYSiLebN+sE8wEk7hVoht3SowSKBjBT8BJwg+hqBEhAfL1IgRJZwivzBdb7OQ5K8l3JiZjoM4Xg2HAcEsWNpmpNK+l6tRvlv2L/dQPtoky712Yh7lpX5dI5sSNAdIVgvtker4+D1LWmcVkDCg9bvYKckPLL+zJpeqbgSp0UoUqPBrmDxFmcmMKC0mOEKrMMpwEsgZZAnzDznJvqEFOFHsXy4U2WPBywXN7geoeABbUDbmw8sgDTEzPnemqrHng8UbhuQ7HcWHUqZTqlg99U5XnDQrxw5UkORZ3d3m9fiAvsOfDaar6/qWS+6If69x3CmQ== macbook"
      ];
    };
  };

  nix.settings.allowed-users = [ "nik" ];

  environment.systemPackages =
    with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [
      bash-completion
      git
      nixfmt
      wget
    ];
  ###

  networking = {
    hostName = "hetzner-x86";
    interfaces.enp1s0 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c0c:6600::";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  system.stateVersion = "22.05";

}
