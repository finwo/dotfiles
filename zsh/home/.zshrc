# vim:fdm=marker:fdl=0

# OSX coreutils {{{

if command -v brew &>/dev/null; then
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
fi

# }}}
# History {{{

# Track
HISTFILE=~/.histfile
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt HIST_IGNORE_DUPS
bindkey -v

# Search
[[ -n "${key[PageUp]}"   ]] && bindkey "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" history-beginning-search-forward

# }}}
# Custom commands {{{

function getComposer {
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
}

function composer {
  for i in $(echo {,~/bin/,/usr/bin/,/usr/local/bin/}composer{.phar,}); do
    [ -f "$i" ] || continue
    php "$i" "$@"
    return $?
  done
  echo "Composer is not installed on this system"
  return 1
}

# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
function version() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
      grep '"tag_name":' |                                            # Get tag line
      sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# }}}
# Aliases {{{

# VI
command -v "nvim" &>/dev/null && alias vim="nvim"
command -v "vim"  &>/dev/null && alias vi="vim"

# LS
alias ls="ls --color=always"
alias ll="ls -lsa"

# $EDITOR
command -v ed   &>/dev/null && export EDITOR=ed
command -v vi   &>/dev/null && export EDITOR=vi
command -v vim  &>/dev/null && export EDITOR=vim
command -v nvim &>/dev/null && export EDITOR=nvim

# }}}
# Auto-correct {{{

# Correction
setopt correct
setopt correctall

# Command not found
if [[ -s '/etc/zsh_command_not_found' ]]; then
  source '/etc/zsh_command_not_found'
fi

# }}}
# Tab-completion {{{

# Command & folder completion
autoload -Uz compinit promptinit && compinit && promptinit
zstyle ':completion:*' menu select
setopt completealiases

# Known_hosts
if [ -f "~/.ssh/known_hosts" ]; then
  local knownhosts
  knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
  zstyle ':completion:*:(ping|dig|ssh|scp|sftp|mosh|nc|ncat):*' hosts $knownhosts
fi

# }}}
# Fixes {{{

# TERM
if [[ $TERM == screen* ]]; then
  export TERM=${TERM#screen.}
  export SCREEN=yes
fi

# Auto-cd
setopt autocd

# GPG
export GPG_TTY=$(tty)

# npm-gyp performance
export npm_config_jobs=$(( $(nproc) + 1 ))

# }}}
# Prompt {{{

autoload -U colors && colors
autoload -U promptinit && promptinit
prompt="%(?..[%{$fg[red]%}%?%{$reset_color%}] )%{$fg[yellow]%}%n%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}%# "
PROMPT_COMMAND=

# }}}
# Titles {{{

[[ -e ~/src/finwo/zsh-titles/titles.plugin.zsh ]] && source ~/src/finwo/zsh-titles/titles.plugin.zsh

# }}}
# FuzzyFinder {{{
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}
# Google Cloud SDK {{{
# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi
# }}}
# Go binaries {{{
if [ -d "${HOME}/go/bin" ]; then
  export PATH="${HOME}/go/bin:${PATH}"
fi
# }}}
# Symfony {{{
if [ -d "${HOME}/.symfony/bin" ]; then
  export PATH="${HOME}/.symfony/bin:${PATH}"
fi
# }}}
