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

## git
gitinit() {
    if [ -z "$1" ]; then
        echo "Usage: gitinit <repo-name>"
        return 1
    fi
    git init
    git remote add origin "https://github.com/$USER/$1.git"
    git branch -M main
    git add $2
    git commit -m "$3"
    git push -u origin main
}
