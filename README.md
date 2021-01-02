# NixOS

## Introduction

As the date of writing (1st January 2021), I've commited myself switching to
NixOS. This repository reflects my current configurations. I'm currently
learning NixOS, which means that those configuration files also reflect my
learning process! They will still change a lot! Some stuff will stay, other
stuff will be changed.  I'm not an expert at NixOS (yet)! But I'm willing to
learn.  In case you think I could do something better don't hesitate to tell me!

## Note of thanks

This one has to go to [@pinpox](https://github.com/pinpox)! Months ago, you
told me about NixOS. You kept me posted while switching your infrastructure to
NixOS. You really are a big help in my current learning process. You took a lot
of time out of your day to explain examples in detail while also helping me with
problems that occured.  Thank you!! You are big help!

## Preamble

After using Arch for most of 2020, I've decided to give NixOS a chance in 2021.
While I'm quite happy with my current Arch Linux workstation, there are some
quite appealing characteristics NixOS has to offer.

When looking at my GitHub projects you will notice: I'm a big fan of Ansible and
other forms of automatically deploying infrastructure. I've ansibled myself
through the ArchLinux install - something Ansible isn't really made for (which
challenged me to do so in the first place!)
([MayNiklas/ansible-arch-setup](https://github.com/MayNiklas/ansible-arch-setup)).
While this project helped me convert friends & family to ArchLinux instead of
Windows, I've decided to try out something different for myself: NixOS.

As I wrote before, I love to define my digital infrastructure with code. The
advantage of using NixOS is simple: it's made for this kind of deployment! I
don't have to ansible my way through the install.

**TL;DR** NixOS offers methods of configuration I formerly had to implement
myself using Ansible. Also, I like to check out new stuff!

---

## Helpful resources

### Official Manuals

- [NixOS official Manual](https://nixos.org/manual/nixos/stable/) The go-to
  place for information about nix and NixOS
- [NixOS unstable Manual](https://nixos.org/manual/nix/unstable/) Includes a lot
  of new stuff, like documentation for the new `nix flakes` command
- [Nix Pills](https://nixos.org/guides/nix-pills/) Tutorial introduction into
  the Nix with a lot of hands-on examples. Definitely worth reading if you
  have the time.

### Other

- Nix & NixOS: Installation with encrypted root [pablo.tools](https://pablo.tools/posts/computers/nixos-encrypted-install/)
- Search NixOS options [search.nixos.org](https://search.nixos.org/options?channel=unstable/)
- Nix Flakes Series by [Eelco Dolstra](https://github.com/edolstra). Great
  introduction to flakes.
  - [part 1](https://www.tweag.io/blog/2020-05-25-flakes/) An introduction and tutorial
  - [part 2](https://www.tweag.io/blog/2020-06-25-eval-cache/) Evaluation caching
  - [part 3](https://www.tweag.io/blog/2020-07-31-nixos-flakes/) Managing NixOS systems
- [Home-manager](https://rycee.gitlab.io/home-manager/) Manual
- [Home-manager](https://rycee.gitlab.io/home-manager/options.html)
  Configuration options reference
- [Why NixOS?](https://www.youtube.com/watch?v=bEUiXDJbwW8) Introduction video
  about NixOS
- [Nix Flakes 101](https://www.youtube.com/watch?v=QXUlhnhuRX4) Good video about
  flakes

### Community

- [NixOS Subreddit](https://www.reddit.com/r/NixOS/)
- Nix/NixOS IRC channels on freenode: `#nixos`, `#nixos-dev`, `#nixos-chat`,
  `#nixos-de`, `#nixops`, `#krebs` (and more)

## Switching to unstable channel

```bash
sudo nix-channel --add https://channels.nixos.org/nixpkgs-unstable/ nixos
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade
```
