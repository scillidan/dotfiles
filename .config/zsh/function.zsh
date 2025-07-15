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

zshgc() {
    git clone --depth=1 "$1" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$2"
}

## jsc
# jc() {
#     jsc -s "$1" | xargs -n 1 -r aria2c
# }

## neovim
nv() {
    if [[ -f "$1" ]]; then
        nvim "$1"
    else
        touch "$1" && nvim "$1"
    fi
}


lnbin() {
    ln -sfn "$(pwd)/$1" ~/.local/bin/"$2"
}
