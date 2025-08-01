export EDITOR="/usr/bin/nvim"
# export BROWSER="/usr/bin/brave"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit snippet "$HOME/.oh-my-zsh/lib/git.zsh"
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit lucid wait for \
  nyoungstudios/zsh-history-on-success \
  Freed-Wu/zsh-help \
  Aloxaf/fzf-tab \
  mfaerevaag/wd \
  Kikolator/proj-jumper \
  raisedadead/zsh-touchplus \
  vxfemboy/zsh-smart-files \
  lgdevlop/zsh-smart-insert \
  mass8326/zsh-chezmoi \
  singular0/zsh-env-secrets \
  sunlei/zsh-ssh \
  SckyzO/zsh-sshinfo \
  raisedadead/zsh-snr \
  soimort/translate-shell \
  pressdarling/codex-zsh-plugin \
  wfxr/forgit \
  Bhupesh-V/ugit \
	andydecleyre/zpy

zi has'zoxide' wait lucid for \
  z-shell/zsh-zoxide

autoload -Uz compinit
compinit

zi snippet "$HOME/.config/zsh/function.zsh"
zi snippet "$HOME/.config/zsh/alias.zsh"

export MANPATH="/usr/share/man:$MANPATH"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.pyenv/bin:$HOME/.local/share/go/bin:$HOME/Usr/Lib/lua53/bin:$HOME/.tmuxifier/bin:$TEXLIVE/bin/x86_64-linux:$PATH"

## zsh
### zsh-env-secrets
ENV_SECRETS=(
  "TENCENT_SECRET_ID"
  "TENCENT_SECRET_KEY"
  "OPENAI_API_KEY"
  "OPENROUTER_API_KEY"
	"GOWL_TOKEN"
)
ENV_SECRETS_BACKEND="pass"
ENV_SECRETS_QUIET=1

### rose-pine-man
zi snippet "$ZSH_CUSTOM/plugins/rose-pine-man/rose-pine-man.zsh"

### zsh-help
help_function() {
  bat -plhelp --paging=always --color=always
}

### zsh-smart-insert
export ZSH_SMART_INSERT_PREFIXES="nvim:subl:less"
export ZSH_SMART_INSERT_IGNOREDIRS=".git/*:node_modules/:dist/:.venv/:public/:site/"

### zsh-vi-mode
# ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
function zvm_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
	## atuin
	eval "$(atuin init zsh --disable-up-arrow)"
	## carapace
	export CARAPACE_BRIDGES='zsh'
	zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
	zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
	source <(carapace _carapace)
	## fzf
	# export FZF_CTRL_T_COMMAND=""
	# export FZF_DEFAULT_COMMAND=""
	# export ENHANCD_FILTER="fzy:fzf --height 40%"
	source <(fzf --zsh)
	## fzf-tab
	zstyle ':completion:*' ignore-case 'yes'
	if [[ -v TMUX ]]; then
			zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
	fi
	## grc
	[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
	## tmux
	export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
	export TMUXIFIER_TMUX_OPTS=""
	eval "$(tmuxifier init -)"
}
zvm_after_init_commands+=(zvm_init)

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

## cargo
export CARGO_TARGET_DIR="$HOME/.cargo/tmp"
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"

## go
export GOPATH="$HOME/.local/share/go"

## gvm
# export GVM_ROOT="$HOME/.gvm"
# [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

## lua
# export LUA_PATH="$ROOT/usr/share/lua/5.1/luarocks/?.lua;$ROOT/usr/share/lua/5.1/luarocks/?/init.lua"
# export LUA_CPATH="$ROOT/usr/share/lua/5.1/?.so"
source "$HOME/Usr/Lib/lua51/bin/activate"

## miniconda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

## nvm
source "/usr/share/nvm/init-nvm.sh"

## pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
# eval "$(pyenv virtualenv-init -)"

## python
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

## rbenv
# eval "$(rbenv init -)"

# bindkey '^ ' expand-or-complete-prefix
# bindkey -s '^v' 'nvim $(fzf)\n'

zi snippet "$ZSH_CUSTOM/themes/minimal/minimal.zsh"

# eval "clear"
