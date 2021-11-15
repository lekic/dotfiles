BREW_PREFIX=$(brew --prefix)

autoload -U promptinit; promptinit
prompt pure

source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source $BREW_PREFIX/etc/profile.d/z.sh