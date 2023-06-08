SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
OS := $(shell bin/is-supported bin/is-macos macos linux)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-macos $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local) /home/linuxbrew/.linuxbrew)
SHELLS := /private/etc/shells
BIN := $(HOMEBREW_PREFIX)/bin
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: test

all: $(OS)

macos: sudo core-macos packages link

linux: core-linux link

core-macos: brew zsh git npm ruby rust

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

packages: brew-packages cask-apps node-packages rust-packages

link: stow-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	$(BIN)/stow -t $(HOME) runcom
	$(BIN)/stow -t $(XDG_CONFIG_HOME) config

unlink: stow-$(OS)
	$(BIN)/stow --delete -t $(HOME) runcom
	$(BIN)/stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

zsh: brew
ifdef GITHUB_ACTION
	if ! grep -q $(BIN)/zsh $(SHELLS); then \
		$(BIN)/brew install bash bash-completion@2 pcre zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting z && \
		sudo append $(BIN)/zsh $(SHELLS) && \
		sudo chsh -s $(BIN)/zsh; \
	fi
else
	if ! grep -q $(BIN)/zsh $(SHELLS); then \
		$(BIN)/brew install bash bash-completion@2 pcre zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting z && \
		sudo append $(BIN)/zsh $(SHELLS) && \
		chsh -s $(BIN)/zsh; \
	fi
endif

git: brew
	$(BIN)/brew install git git-extras

npm: brew-packages
	$(BIN)/fnm install --lts

ruby: brew
	$(BIN)/brew install ruby

rust: brew
	$(BIN)/brew install rust

brew-packages: brew
	$(BIN)/brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

cask-apps: brew
	$(BIN)/brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done

node-packages: npm
	eval $$(fnm env); npm install -g $(shell cat install/npmfile)

rust-packages: rust
	$(BIN)/cargo install $(shell cat install/Rustfile)

test:
	eval $$(fnm env); bats test
