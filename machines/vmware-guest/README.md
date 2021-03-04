# vmware-guest

EFI install without swap partition
```bash
# create partitions
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary 512MiB 100%

# format partitions
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

# mount partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# clone repository
sudo nix run nixpkgs.git -c git clone https://github.com/MayNiklas/nixos.git /mnt/etc/nixos

# link config
sudo ln -s /mnt/etc/nixos/machines/vmware-guest/configuration.nix /mnt/etc/nixos/configuration.nix

# install os
nixos-install
```
