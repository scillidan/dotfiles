## atuin
eval "$(atuin init zsh --disable-up-arrow)"

## broot
# source $HOME/.config/broot/launcher/bash/br

## carapace
export CARAPACE_BRIDGES='zsh'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
source <(carapace _carapace)

## fzf
source <(fzf --zsh)

## fzf-tab
zstyle ':completion:*' ignore-case 'yes'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
## fzf-tab-completion
zstyle ':completion:*:*:git:*' fzf-search-display true
# zstyle ':completion::*:ls::*' fzf-completion-oddpts --preview='eval head {1}'
# zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}'
zstyle ':completion::*:git::git,add,*' fzf-completion-opts --preview='git -c color.status=always status --short'
zstyle ':completion::*:git::*,[a-z]*' fzf-completion-opts --preview='
eval set -- {+1}
for arg in "$@"; do
    { git diff --color=always -- "$arg" | git log --color=always "$arg" } 2>/dev/null
done'

## grc
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

## starship
# eval "$(starship init zsh)"

## tere
tere() {
  local result=$(command tere "$@")
  [ -n "$result" ] && cd -- "$result"
}

## tmux
export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
export TMUXIFIER_TMUX_OPTS=""
eval "$(tmuxifier init -)"

## zellij
# zellij_tab_name_update() {
#   if [[ -n $ZELLIJ ]]; then
#     local current_dir=$PWD
#     if [[ $current_dir == $HOME ]]; then
#       current_dir="~"
#     else
#       current_dir=${current_dir##*/}
#     fi
#       command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
# 	fi
# }
# zellij_tab_name_update
# chpwd_functions+=(zellij_tab_name_update)

## zsh

### proj-jumper
export PROJ_DEV_ROOT="$HOME/Usr/Proj"

### zsh-abbr
source ${ZSH_CUSTOM}/plugins/zsh-abbr/zsh-abbr.zsh

### zsh-help
help_function() {
  bat -plhelp --paging=always --color=always
}

### zsh-smart-insert
export ZSH_SMART_INSERT_PREFIXES="nvim:subl:less"
export ZSH_SMART_INSERT_IGNOREDIRS=".git/*:node_modules/:dist/:.venv/:public/:site/"

