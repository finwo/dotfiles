
# History
HISTFILE=~/.histfile
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt HIST_IGNORE_DUPS
bindkey -v

# History search
[[ -n "${key[PageUp]}"   ]] && bindkey "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" history-beginning-search-forward

# Aliases
command -v "nvim" &>/dev/null && alias vim="nvim"
command -v "vim"  &>/dev/null && alias vi="vim"

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
