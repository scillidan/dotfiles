## bookmarks.txt
bkm() {
  bookmarks | fzf | cut -d' ' -f1 | xargs librewolf
}

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
rfs() {
  local RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  local OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
                nvim {1} +{2}
             else
                local cmds=()
                while read -r line; do
                  local file=$(echo "$line" | cut -d: -f1)
                  local lineno=$(echo "$line" | cut -d: -f2)
                  cmds+=( "+call cursor($lineno,1)" "$file" )
                done < <(cat {+f})
                nvim "${cmds[@]}"
             fi'
  local OPENER_SUBL='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
                    subl {1}:{2}
                  else
                    params=()
                    while read -r line; do
                      file=$(echo "$line" | cut -d: -f1)
                      line_no=$(echo "$line" | cut -d: -f2)
                      col_no=$(echo "$line" | cut -d: -f3)
                      params+=( "${file}:${line_no}:${col_no}" )
                    done < <(cat {+f})
                    subl "${params[@]}"
                  fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind "ctrl-e:execute:$OPENER_SUBL" \
      --bind 'ctrl-u:preview-up,ctrl-d:preview-down,alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat -n --theme=base16 --color=always --highlight-line {2} {1}' \
      --preview-window '~1,+{2}+4/3,<80(up)' \
      --query "$*"
}
rff() {
  local FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  local selected
  selected=$(fzf --ansi --multi --height=100% --layout=reverse --inline-info \
    --bind "ctrl-o:execute(nvim {} > /dev/tty)+abort" \
    --bind "ctrl-e:execute(subl {} > /dev/tty)+abort" \
    --bind "enter:execute-silent(realpath {+} | xargs printf '%s\n' | head -c -1 | xclip -selection clipboard)+abort" \
    --bind 'ctrl-u:preview-up,ctrl-d:preview-down,alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
    --preview 'bat -n --theme=base16 --color=always {}' \
    --query "$*")
  if [[ -n "$selected" ]]; then
    local abs_paths=()
    while IFS= read -r line; do
      abs_paths+=("$(realpath "$line")")
    done <<< "$selected"
    printf '%s ' "${abs_paths[@]}"
    echo
  fi
}

## git
gitinit() {
  local repo_name="$1"
  local add_files="$2"
  local commit_msg="$3"
  if [ -z "$repo_name" ]; then
      echo "Usage: gitinit <repo-name>"
      return 1
  fi
  git init
  git remote add origin "https://github.com/$USER/$repo_name.git"
  git branch -M main
  git add $add_files
  git commit -m "$commit_msg"
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
  local source=$1
  local target=$2
  ln -sfn "$(pwd)/$source" ~/.local/bin/"$target"
}
