## NixOS
### introduction
As the date of writing (1st January 2021), I've commited myself switching to NixOS. This repository reflects my current configurations. I'm currently learning NixOS, which means that those configuration files also reflect my learning process! Configurations will still change a lot! Some stuff will stay, other stuff will be drawn out.
I'm not an expert at NixOS (yet)! But I'm willing to learn.
In case you think I could do something better - don't hesitate to tell me!

### note of thanks
This one has to go to @pinpox !
Months ago, you told me about NixOS. You kept me posted while switching your infrastructure to NixOS. You really are a big help in my current learning process. You took yourself a lot of time explaining stuff in detail while also helping me with problems that accured.
Thank you!! You are big help!

### preamble
After using Arch for most of 2020, I've decided to give NixOS a chance in 2021. While I'm quite happy with my current Arch Linux workstation, there are some quite appearing characteristics NixOS has to offer.

When looking at my GitHub projects you will notice: I'm a big fan of Ansible and other forms of automatically deploying infrastructure. I've ansibled myself through the ArchLinux install - something Ansible isn't really made for (which challenged me to do so in the first place!).
While this project helped me to convert friends & family using ArchLinux instead of Windows, personally I've decided to try out something different for myself: NixOS.

As I wrote before, I love to put my infrastructure into some form of code. The advantage of using NixOS is simple: it's made for this kind of deployment! I don't have to ansible my way through the install.

**TL;DR** NixOS offers methods of configuration, I former had to implement myself using Ansible. Also: I like to check out new stuff!

---

### helpful ressources:
- Nix & NixOS: Installation with encrypted root [pablo.tools](https://pablo.tools/posts/computers/nixos-encrypted-install/)
- Search NixOS options [search.nixos.org](https://search.nixos.org/options?channel=unstable/)


### adding unstable channels
```bash
sudo nix-channel --add https://channels.nixos.org/nixpkgs-unstable/ nixos
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade
```
