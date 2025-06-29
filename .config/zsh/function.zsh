## fzf
# https://github.com/argosatcore/Deb_Dots/blob/main/.bash_functions.sh
fkill() {
  local pid
  pid="$(
    ps -ef |
      sed 1d |
      fzf -e -m --cycle --reverse |
      awk '{print $2}'
  )" || return
  kill -"${1:-9}" "$pid" &>/dev/null
}
