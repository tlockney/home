# My Home Bootstrap Repo

This repo is how I bootstrap my home directory on various machines

This is **very** much still a work in progress.

## Getting Started

Running the following to bootstrap a new machine. The weirdness with the git remote url is to avoid needing to authenticate on the initial pull.

```sh
cd $HOME
curl -sfL https://git.io/chezmoi | sh
~/bin/chezmoi init https://github.com/tlockney/home.git
cd ~/.local/share/chezmoi
git remote set-url origin https://github.com/tlockney/home.git
```