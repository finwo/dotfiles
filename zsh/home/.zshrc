for file in $(ls "${HOME}/.config/zsh/rc/"); do
  source "${HOME}/.config/zsh/rc/${file}"
done
