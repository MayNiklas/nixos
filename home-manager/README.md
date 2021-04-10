# nixos-home

## Installing Home Manager

```bash
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --update
nix-shell '<home-manager>' -A install
```

## Cloning home-manager configs
```bash
# removing default configs
rm -rf ~/.config/nixpkgs
# clone via https
git clone https://github.com/MayNiklas/nixos-home.git ~/.config/nixpkgs
# clone via ssh
git clone git@github.com:MayNiklas/nixos-home.git ~/.config/nixpkgs
```

## Switching to configs
```bash
# For desktops
home-manager switch

# For servers
home-manager  -f .config/nixpkgs/home-server.nix switch
```

## Updating flakes.lock file
```bash
nix flake update --recreate-lock-file
git add flake.lock
git commit -m "↗️ update flake.lock"
git push
```
