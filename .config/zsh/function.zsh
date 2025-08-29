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
# https://junegunn.github.io/fzf/tips/ripgrep-integration
rfnv() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            nvim {1} +{2}
          else
            nvim +cw -q {+f}
          fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'ctrl-u:preview-up,ctrl-d:preview-down,alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat -n --theme=base16-256 --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)

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

## yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

lnbin() {
    ln -sfn "$(pwd)/$1" ~/.local/bin/"$2"
}
