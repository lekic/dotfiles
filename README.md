# dotfiles

![Dotfiles Install](https://github.com/lekic/dotfiles/actions/workflows/dotfiles-installation.yml/badge.svg)
![Markdown Link Checker](https://github.com/lekic/dotfiles/actions/workflows/markdown-link-checker.yml/badge.svg)
![Spellcheck](https://github.com/lekic/dotfiles/actions/workflows/spellcheck.yml/badge.svg)

These are my dotfiles. Take anything you want, but at your own risk.

It mainly targets macOS systems (should install on Ubuntu as well for many tools, config and aliases etc).

## Highlights

- Minimal efforts to install everything, using a [Makefile](./Makefile)
- Mostly based around Homebrew, Caskroom and Node.js, latest Zsh + GNU Utils
- Great [Window management](./config/hammerspoon/README.md) (using Hammerspoon)
- Fast and coloured prompt
- Updated macOS defaults
- Well-organised and easy to customise
- The installation and runcom setup is [tested weekly on real Ubuntu and macOS machines](https://github.com/lekic/dotfiles/actions) (Ventura/13, Sonomo/14, Sequoia/15) using [a GitHub Action](./.github/workflows/dotfiles-installation.yml)
- Supports both Apple Silicon (M1) and Intel chips

## Packages Overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- [Node.js + npm LTS](https://nodejs.org/en/download/) (packages: [npmfile](./install/npmfile))
- [VSCode](https://code.visualstudio.com) (packages: [Codefile](./install/Codefile))
- Latest Git, Zsh, Python, GNU coreutils, curl, Ruby
- [Hammerspoon](https://www.hammerspoon.org) (config: [keybindings & window management](./config/hammerspoon))
- [Mackup](https://github.com/lra/mackup) (sync application settings)
- `$EDITOR` (and Git editor) is [Vim](https://www.vim.org/)

## Installation

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
sudo softwareupdate --install-rosetta --agree-to-license
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS). Now there are two options:

1. Install this repo with `curl` available:

```bash
bash -c "`curl -fsSL https://raw.githubusercontent.com/lekic/dotfiles/main/remote-install.sh`"
```

This will clone or download this repo to `~/.dotfiles` (depending on the availability of `git`, `curl` or `wget`).

1. Alternatively, clone manually into the desired location:

```bash
git clone https://github.com/lekic/dotfiles.git ~/.dotfiles
```

2. Use the [Makefile](./Makefile) to install the [packages listed above](#packages-overview), and symlink [runcom](./runcom) and [config](./config) files (using [stow](https://www.gnu.org/software/stow/)):

```bash
cd ~/.dotfiles
make
```

Running `make` with the Makefile is idempotent. The installation process in the Makefile is tested on every push and every week in this
[GitHub Action](https://github.com/lekic/dotfiles/actions). Please file an issue in this repo if there are errors.

## Post-Installation

1. Set your Git credentials:

```sh
git config --global user.name "your name"
git config --global user.email "your@email.com"
git config --global github.user "your-github-username"
```

2. Set macOS [Dock items](./macos/dock.sh) and [system defaults](./macos/defaults.sh):

```sh
dot dock
dot macos
```

3. Start Hammerspoon once and set "Launch Hammerspoon at login".

4. For Mackup, login to iCloud and wait for it to sync, the run the following.

```sh
cd && ln -s ~/.config/mackup/.mackup.cfg ~
mackup restore
```

4. Populate this file with tokens (example: `export GITHUB_TOKEN=abc`):

```sh
touch ~/.dotfiles/system/.exports
```

## The `dot` command

```bash
$ dot help
Usage: dot <command>

Commands:
   clean            Clean up caches (brew, npm, gem, rvm)
   dock             Apply macOS Dock settings
   edit             Open dotfiles in IDE ($VISUAL)
   help             This help message
   macos            Apply macOS system defaults
   test             Run tests
   update           Update packages and pkg managers (brew, casks, cargo, pip3, npm, gems, macOS)
```

## Customise

You can put your custom settings, such as Git credentials in the `system/.custom` file which will be sourced from
`.profile` automatically. This file is in `.gitignore`.

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`. The runcom `.profile` sources all
`~/.extra/runcom/*.sh` files.

## Additional Resources

- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [Homebrew](https://brew.sh)
- [Homebrew Cask](https://github.com/Homebrew/homebrew-cask)
- [Bash prompt](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)
- [Solarized Color Theme for GNU ls](https://github.com/seebi/dircolors-solarized)

## Credits

Many thanks to the [dotfiles community](https://dotfiles.github.io), in particular [webpro's dotfiles](https://github.com/webpro/dotfiles), which heavily influenced my own.
