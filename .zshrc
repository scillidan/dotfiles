if [ ! -n "$ZSH" ]; then
ZSH=~/.oh-my-zsh
fi
source "$ZSH/oh-my-zsh.sh"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

plugins=(
  git
  zsh-help
  smart-files
  chezmoi
  zsh-env-secrets
)

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light nyoungstudios/zsh-history-on-success
zinit light z-shell/zsh-zoxide
zinit light Aloxaf/fzf-tab
zinit wait lucid for mfaerevaag/wd
zinit wait lucid for raisedadead/zsh-touchplus
zinit wait lucid for lgdevlop/zsh-smart-insert
zinit wait lucid for sunlei/zsh-ssh
zinit wait lucid for raisedadead/zsh-snr
zinit wait lucid for soimort/translate-shell
zinit wait lucid for wfxr/forgit
zinit wait lucid for Bhupesh-V/ugit
zinit wait lucid for andydecleyre/zpy

source "$HOME/.zshenv"
source "$HOME/.config/zsh/config.zsh"
source "$HOME/.config/zsh/library.zsh"
source "$HOME/.config/zsh/function.zsh"
source "$HOME/.config/zsh/alias.zsh"

# bindkey '^ ' expand-or-complete-prefix
# bindkey -s '^v' 'nvim $(fzf)\n'

autoload -U compinit
compinit -u

# ZSH_THEME=""
source "${ZSH_CUSTOM}/themes/minimal/minimal.zsh"

eval "clear"
