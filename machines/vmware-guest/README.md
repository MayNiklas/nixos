# vmware-guest

EFI install without swap partition
```bash
# execute as root
sudo su

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

# generate hardware-configuration.nix
nixos-generate-config --root /mnt

# mv hardware-configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix ~/

# delete /mnt/etc/nixos
rm -rf /mnt/etc/nixos

# clone repository
nix run nixpkgs.git -c git clone https://github.com/MayNiklas/nixos.git /mnt/etc/nixos

# recover generated hardware-configuration.nix
mv ~/hardware-configuration.nix /mnt/etc/nixos/machines/vmware-guest/

# link config
ln -s /mnt/etc/nixos/machines/vmware-guest/configuration.nix /mnt/etc/nixos/configuration.nix

# install os
nixos-install
```
