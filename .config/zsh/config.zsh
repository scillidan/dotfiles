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
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

## grc
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

## starship
eval "$(starship init zsh)"

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
### zsh-help
help_function() {
  bat -plhelp --paging=always --color=always
}

### zsh-abbr
source $ZSH_CUSTOM/plugins/zsh-abbr/zsh-abbr.zsh
