## atuin
eval "$(atuin init zsh --disable-up-arrow)"

## carapace
export CARAPACE_BRIDGES='zsh'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
source <(carapace _carapace)

## fzf
source <(fzf --zsh)
# export FZF_CTRL_T_COMMAND=""
# export FZF_DEFAULT_COMMAND=""
# export ENHANCD_FILTER="fzy:fzf --height 40%"

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
zstyle ':completion:*' fzf-search-display true

## grc
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

## neovim
### rime-ls
export LIBRIME_LIB_DIR="$HOME/.local/lib/rime/dist/lib"
export LIBRIME_INCLUDE_DIR="$HOME/.local/lib/rime/dist/include"
export LIB="$HOME/.local/lib/rime/dist/lib"

## ollama
export OLLAMA_HOST="revios"
export OLLAMA_ORIGINES="*"

## sdcv
export STARDICT_DATA_DIR="$HOME/Usr/File/file_sdcv"

## texlive
export INFOPATH="$TEXLIVE/texmf-dist/doc/info"
export MANPATH="$TEXLIVE/texmf-dist/doc/man"
export TEXLIVE="/usr/local/texlive/2025"

## tmux
export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
export TMUXIFIER_TMUX_OPTS=""
eval "$(tmuxifier init -)"

## zsh
### rose-pine-man
source ${ZSH_CUSTOM}/plugins/rose-pine-man/rose-pine-man.zsh

### zsh-help
help_function() {
  bat -plhelp --paging=always --color=always
}

### zsh-smart-insert
export ZSH_SMART_INSERT_PREFIXES="nvim:subl:less"
export ZSH_SMART_INSERT_IGNOREDIRS=".git/*:node_modules/:dist/:.venv/:public/:site/"

