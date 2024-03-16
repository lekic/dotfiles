DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-macos $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local) /home/linuxbrew/.linuxbrew)
PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash
SHELLS := /private/etc/shells
BIN := $(HOMEBREW_PREFIX)/bin
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: test

all: $(OS)

macos: sudo core-macos packages link duti

linux: core-linux link

core-macos: brew zsh git npm

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

packages: brew-packages cask-apps node-packages rust-packages vscode-extensions

link: stow-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p "$(XDG_CONFIG_HOME)"
	stow -t "$(HOME)" runcom
	stow -t "$(XDG_CONFIG_HOME)" config
	mkdir -p $(HOME)/.local/runtime
	chmod 700 $(HOME)/.local/runtime	

unlink: stow-$(OS)
	stow --delete -t "$(HOME)" runcom
	stow --delete -t "$(XDG_CONFIG_HOME)" config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

zsh: brew
ifdef GITHUB_ACTION
	if ! grep -q zsh $(SHELLS); then \
		brew install bash bash-completion@2 pcre zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting z && \
		sudo append zsh $(SHELLS) && \
		sudo chsh -s zsh; \
	fi
else
	if ! grep -q zsh $(SHELLS); then \
		brew install bash bash-completion@2 pcre zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting z && \
		sudo append zsh $(SHELLS) && \
		chsh -s zsh; \
	fi
endif

git: brew
	brew install git git-extras

npm: brew-packages
	fnm install --lts

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

vscode-extensions: cask-apps
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done

node-packages: npm
	eval $$(fnm env); npm install --force --location global $(shell cat install/npmfile)

rust-packages: brew-packages
	cargo install $(shell cat install/Rustfile)

duti: brew-packages
	duti -v $(DOTFILES_DIR)/install/duti

test:
	eval $$(fnm env); bats test
