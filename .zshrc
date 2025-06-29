## termux
if [ ! -n "$ZSH" ]; then
ZSH=~/.oh-my-zsh
fi

source "$ZSH/oh-my-zsh.sh"

source "$HOME/.zshenv"

## zinit
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
  zsh-proxy
)

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light nyoungstudios/zsh-history-on-success
zinit light z-shell/zsh-zoxide
zinit light Aloxaf/fzf-tab
zinit wait lucid for raisedadead/zsh-touchplus
zinit wait lucid for lgdevlop/zsh-smart-insert
zinit wait lucid for sunlei/zsh-ssh
zinit wait lucid for raisedadead/zsh-snr
zinit wait lucid for soimort/translate-shell
zinit wait lucid for wfxr/forgit
zinit wait lucid for Bhupesh-V/ugit
zinit wait lucid for andydecleyre/zpy

source "$ZSH_DOTFILES/config.zsh"
source "$ZSH_DOTFILES/library.zsh"
source "$ZSH_DOTFILES/function.zsh"
source "$ZSH_DOTFILES/alias.zsh"

# bindkey '^ ' expand-or-complete-prefix
# bindkey -s '^v' 'nvim $(fzf)\n'

# ZSH_THEME=""
source "${ZSH_CUSTOM}/themes/minimal/minimal.zsh"

eval "clear"

