export HOME=/home/$USER
source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
source "$HOME/.zshenv"

## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

plugins=(
  git
  zsh-history-on-success
  zsh-help
  proj-jumper
  smart-files
  zsh-env-secrets
  zsh-proxy
  # chezmoi
)

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light mfaerevaag/wd
zinit light z-shell/zsh-zoxide
zinit light Aloxaf/fzf-tab
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
zinit wait lucid for raisedadead/zsh-touchplus
zinit wait lucid for lgdevlop/zsh-smart-insert
zinit wait lucid for sunlei/zsh-ssh
zinit wait lucid for raisedadead/zsh-snr
zinit wait lucid for soimort/translate-shell
zinit wait lucid for wfxr/forgit
zinit wait lucid for Bhupesh-V/ugit
zinit wait lucid for andydecleyre/zpy

export ZSH_DOTFILES="$HOME/.config/zsh"
source "$ZSH_DOTFILES/config.zsh"
source "$ZSH_DOTFILES/library.zsh"
source "$ZSH_DOTFILES/function.zsh"
source "$ZSH_DOTFILES/alias.zsh"

# bindkey '^ ' expand-or-complete-prefix
# bindkey -s '^v' 'nvim $(fzf)\n'
bindkey ${FZF_WD_BINDKEY:-'^B'} wd_browse_widget

autoload -Uz compinit
compinit

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/go/bin:$HOME/Usr/Lib/lua51/bin:$HOME/.tmuxifier/bin:$TEXLIVE/bin/x86_64-linux:$PATH"

# ZSH_THEME=""
source "${ZSH_CUSTOM}/themes/minimal/minimal.zsh"

eval "clear"
