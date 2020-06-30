# vim:fdm=marker:fdl=0

# Homebrew {{{

if [ -d /home/linuxbrew/.linuxbrew ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# }}}
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

[[ -e ~/src/jreese/zsh-titles/titles.plugin.zsh ]] && source ~/src/jreese/zsh-titles/titles.plugin.zsh

# }}}
# FuzzyFinder {{{
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}
# Google Cloud SDK {{{

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/finwo/google-cloud-sdk/path.zsh.inc' ]; then
  . '/home/finwo/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/finwo/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/home/finwo/google-cloud-sdk/completion.zsh.inc'
fi

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
# Rust support {{{
if [ -d "${HOME}/.cargo/bin" ]; then
  export PATH="${HOME}/.cargo/bin:${PATH}"
fi
# }}}
# Global composer {{{

# Simple composer fetcher
function getComposer {
  curl https://getcomposer.org/installer | php
}

# Auto-detects where composer(.phar) is installed
function composer {
  for p in $(echo $PATH | tr ':' '\n'); do
    for i in $(echo composer{.phar,}); do
      [ -f "$p/$i" ] || continue
      php "$p/$i" "$@"
      return $?
    done
  done
  for i in $(echo {,\~/,{/usr,/opt}{/local,}/bin/}composer{.phar,}); do
    [ -f "$i" ] || continue
    php "$i" "$@"
    return $?
  done
  echo "composer is not installed on this system"
  return 1
}

# Use composer-installed binaries
if [ -d "${HOME}/.config/composer/vendor/bin" ]; then
  export PATH="${HOME}/.config/composer/vendor/bin:${PATH}"
fi

# }}}
# Node Version Manager {{{
if [ -d "${HOME}/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
# }}}
# qemu-create {{{
function qemu-create () {

  # Detect the VM settings
  NAME="${1:-machine}"
  HDSIZE="${2:-40G}"

  # Create a directory for it
  mkdir -p "${NAME}"

  # Write run.sh
  cat <<EOF > "${NAME}/run.sh"
#!/usr/bin/env bash
cd \$(dirname \$0)
ARGS=()
ARGS+=" -display gtk"
ARGS+=" -smp 2"
ARGS+=" -soundhw all"
ARGS+=" -m \${mem:-2048}"
ARGS+=" -name \${name:-\$(basename \$(pwd))}"
ARGS+=" -nic user"
command -v 'kvm-ok' &>/dev/null && kvm-ok &>/dev/null && ARGS+=" --enable-kvm"
[ -f boot.efi  ] && ARGS+=" -kernel boot.efi"
[ -f vmlinuz   ] && ARGS+=" -kernel vmlinuz"
[ -f sda.qcow  ] && ARGS+=" -hda sda.qcow"
[ -f sda.img   ] && ARGS+=" -hda sda.img"
[ -f cdrom.iso ] && ARGS+=" -cdrom cdrom.iso -boot d"
qemu-system-x86_64 \${ARGS}
EOF

  # Make run.sh executable
  chmod +x "${NAME}/run.sh"

  # Create the drive image
  qemu-img create -f qcow2 "${NAME}/sda.qcow" "${HDSIZE}"

}
# }}}
# nativescript {{{
if [ -f /home/finwo/.tnsrc ]; then 
    source /home/finwo/.tnsrc 
fi
# }}}
