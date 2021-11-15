BREW_PREFIX=$(brew --prefix)

FPATH=$BREW_PREFIX/share/zsh-completions:$FPATH
autoload -Uz compinit
# If compinit has insecure directories run `compaudit | xargs chmod g-w`
compinit