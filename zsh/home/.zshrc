# vim:fdm=marker:fdl=0
# set -ex

# Homebrew {{{

# Linuxbrew
if [ -d /home/linuxbrew/.linuxbrew ]; then
  # eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
  export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
  export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
  export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info${INFOPATH+:$INFOPATH}";
fi

# openjdk 11 on osx
if [ -d "/opt/homebrew/opt/openjdk@11/bin" ]; then
  export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
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
# Python binaries {{{
if [ -d "${HOME}/.local/bin" ]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi
# }}}
# OSX coreutil fixes {{{

command -v gcp &>/dev/null && alias cp="gcp"
command -v gls &>/dev/null && alias ls="gls"
command -v gmv &>/dev/null && alias mv="gmv"
command -v grm &>/dev/null && alias rm="grm"

# }}}
# Aliases {{{

# VI
command -v "nvim" &>/dev/null && alias vim="nvim"
command -v "vim"  &>/dev/null && alias vi="vim"

# LS
alias ls="ls --color=always"
alias ll="ls -lsa"

# OSX LS fix
command -v gls &>/dev/null && alias ls="gls --color=always"

# $EDITOR
command -v nano &>/dev/null && export EDITOR=nano
command -v vi   &>/dev/null && export EDITOR=vi
command -v vim  &>/dev/null && export EDITOR=vim
command -v nvim &>/dev/null && export EDITOR=nvim

# Git shorthands
alias gc="git commit --no-verify"

# }}}
# Auto-correct {{{

# Correction
setopt correct
setopt correctall

# Command not found
if [[ -s '/etc/zsh_command_not_found' ]]; then
  source '/etc/zsh_command_not_found'
fi

# Typo corrector
if command -v thefuck &>/dev/null; then
  eval "$(thefuck --alias)"
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

# # TERM
# # nvim has issues with xterm-256color
# if [[ $TERM == xterm-256color ]]; then
#   export TERM=xterm-color
# fi

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
prompt="[%{$fg[white]%}%D{%H:%M}%{$reset_color%}] %(?..[%{$fg[red]%}%?%{$reset_color%}] )%{$fg[yellow]%}%n%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}%# "
PROMPT_COMMAND=

# }}}
# Titles {{{

[[ -e ~/src/jreese/zsh-titles/titles.plugin.zsh ]] && source ~/src/jreese/zsh-titles/titles.plugin.zsh

# }}}
# FuzzyFinder {{{
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}
# Google Cloud SDK {{{

# Gcloud sdk doesn't support python 3.10 yet
# Using python2 as compatibility layer
if [ -d '/home/finwo/google-cloud-sdk' ] || [ -d '/home/finwo/Downloads/google-cloud-sdk' ]; then
  export CLOUDSDK_PYTHON=$(which python2)
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/finwo/google-cloud-sdk/path.zsh.inc' ]; then
  . '/home/finwo/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/finwo/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/home/finwo/google-cloud-sdk/completion.zsh.inc'
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/finwo/Downloads/google-cloud-sdk/path.zsh.inc' ]; then
  . '/home/finwo/Downloads/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/finwo/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/home/finwo/Downloads/google-cloud-sdk/completion.zsh.inc'
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

# Load on-demand
nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    echo 'Installing NVM...'
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$(version nvm-sh/nvm)/install.sh" | bash
  fi
  echo 'Loading NVM...'
  unset -f nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm "$@"
}
#
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
if [ -f config ]; then
  source config
fi
ARGS=()
ARGS+=" -display gtk"
ARGS+=" -smp \${cpus:-2}"
ARGS+=" -soundhw all"
ARGS+=" -m \${mem:-2048}"
ARGS+=" -name \${name:-\$(basename \$(pwd))}"
ARGS+=" -nic user"
command -v 'kvm-ok' &>/dev/null && kvm-ok &>/dev/null && ARGS+=" --enable-kvm"
if [ ! -z "\${kernel}" ]; then ARGS+=" -kernel \${kernel}"; fi
if [ ! -z "\${initrd}" ]; then ARGS+=" -kernel \${initrd}"; fi
if [ -z "\${kernel}" ]; then
  [ -f boot.efi   ] && ARGS+=" -kernel boot.efi"
  [ -f kernel.bin ] && ARGS+=" -kernel kernel.bin"
  [ -f vmlinuz    ] && ARGS+=" -kernel vmlinuz"
fi
if [ -z "\${initrd}" ]; then
  [ -f initrd     ] && ARGS+=" -initrd initrd"
  [ -f initrd.gz  ] && ARGS+=" -initrd initrd.gz"
fi
[ -f sda.qcow   ] && ARGS+=" -hda sda.qcow"
[ -f sda.img    ] && ARGS+=" -hda sda.img"
[ -f cdrom.iso  ] && ARGS+=" -cdrom cdrom.iso -boot d"
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
# pnpm {{{
export PNPM_HOME="/home/finwo/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# }}}
# Android Studio {{{

# On a mac
if [ -d ~/Library/Android/sdk ]; then
  export ANDROID_HOME=~/Library/Android/sdk
  export ANDROID_SDK_ROOT=~/Library/Android/sdk
  export ANDROID_AVD_HOME=~/.android/avd
fi

# On linux
if [ -d ~/Android/Sdk ]; then
  export ANDROID_HOME=~/Android/Sdk
  export ANDROID_SDK_ROOT=~/Android/Sdk
  export ANDROID_AVD_HOME=~/.android/avd
fi

# }}}
# kind completion {{{
if command -v kind &>/dev/null; then
  eval "$(kind completion zsh)"
fi
# }}}
# Difftastic in git {{{
if command -v difft &>/dev/null; then
  export GIT_EXTERNAL_DIFF=difft
fi
# }}}
