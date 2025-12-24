# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x readlink ]]; then
  SCRIPT_PATH=$(readlink -n $CURRENT_SCRIPT)
  DOTFILES_DIR="${PWD}/$(dirname $(dirname $SCRIPT_PATH))"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
elif [ -d "$HOME/dotfiles" ]; then
  DOTFILES_DIR="$HOME/dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Fix for Apple Silicon brew install path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Source the dotfiles (order matters)
BREW_PREFIX=$(brew --prefix)

[ -f "$DOTFILES_DIR/system/.exports" ] && . "$DOTFILES_DIR/system/.exports"

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,n,path,env,alias,grep,pnpm,custom}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if [[ "$SHELL" == "$BREW_PREFIX/bin/bash" ]]; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,prompt,completion}.bash; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

if [[ "$SHELL" == "$BREW_PREFIX/bin/zsh" ]]; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,prompt,completion}.zsh; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.cba; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Hook for extra/custom stuff

DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
  for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/runcom/*.sh; do
    [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
  done
fi

# Set LSCOLORS

eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# Clean up

unset CURRENT_SCRIPT SCRIPT_PATH BREW_PREFIX DOTFILE EXTRAFILE

# Export

export DOTFILES_DIR DOTFILES_EXTRA_DIR
