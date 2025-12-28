export EDITOR="/usr/bin/nvim"
export BROWSER="/usr/bin/librewolf"
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
  mass8326/zsh-chezmoi \
  singular0/zsh-env-secrets \
  sunlei/zsh-ssh \
  SckyzO/zsh-sshinfo \
  raisedadead/zsh-snr \
  soimort/translate-shell \
  wfxr/forgit \
  Bhupesh-V/ugit \
	matthiasha/zsh-uv-env \
	andydecleyre/zpy
# pressdarling/codex-zsh-plugin \

zi has'zoxide' wait lucid for \
  z-shell/zsh-zoxide

autoload -Uz compinit
compinit

source "$HOME/.config/zsh/function.zsh"
for config in "${HOME}/.config/zsh/alias"*.yaml; do
    [[ -f "$config" ]] && source "$config"
done

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/go/bin:$PATH"
export PATH="$HOME/Usr/Git/Shell/bin:$PATH"

if [[ -n "$TERMUX_VERSION" ]]; then
  is_termux=1
else
  is_termux=0
fi

if [ "$is_termux" = "0" ]; then
  export STARDICT_DATA_DIR="$HOME/Usr/Data/sdcv"
  export TEXLIVE="/usr/local/texlive/2025"
  export MANPATH="/usr/share/man:$TEXLIVE/texmf-dist/doc/man:MANPATH"
  export PATH="$HOME/Usr/Lib/lua53/bin:$TEXLIVE/bin/x86_64-linux:$PATH"
else
  export STARDICT_DATA_DIR="$HOME/storage/downloads/Usr/Data/sdcv"
  export TEXDIR="/data/data/com.termux/files/usr/local/texlive/2025"
  export TEXLIVE="/data/data/com.termux/files/usr/local/texlive/2025"
  export MANPATH="/data/data/com.termux/files/usr/share/man:$TEXLIVE/texmf-dist/doc/man:MANPATH"
  export PATH="$PATH"
  export PREFIX=
  # nvm
  export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

## zsh-vi-mode
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
	export FZF_DEFAULT_OPTS="--bind='ctrl-u:preview-up,ctrl-d:preview-down,ctrl-o:toggle+up,ctrl-i:toggle+down,ctrl-space:toggle-preview'"
	# export ENHANCD_FILTER="fzy:fzf --height 40%"
	source <(fzf --zsh)
	## fzf-tab
	zstyle ':completion:*' ignore-case 'yes'
	if [[ -v TMUX ]]; then
			zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
	fi
	## grc
	[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
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
	source "$ZSH_CUSTOM/plugins/rose-pine-man/rose-pine-man.zsh"
	### zsh-help
	help_function() {
  	bat -plhelp --paging=always --color=always
	}
	### zsh-smart-insert
	export ZSH_SMART_INSERT_PREFIXES="nvim:subl"
	export ZSH_SMART_INSERT_IGNOREDIRS=".git/*:node_modules/:dist/:.venv/:public/:site/"
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
	# export LUA_PATH="$ROOT/usr/share/lua/5.3/luarocks/?.lua;$ROOT/usr/share/lua/5.3/luarocks/?/init.lua"
	# export LUA_CPATH="$ROOT/usr/share/lua/5.3/?.so"
	## python
	export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
	if (( is_termux == 0 )); then
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
		## rbenv
		export FPATH=$HOME/.rbenv/completions:"$FPATH"
		eval "$(rbenv init -)"
	fi
	zvm_bindkey viins '^R' atuin-search
	zvm_bindkey vicmd '^R' atuin-search
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

## texlive
export INFOPATH="$TEXLIVE/texmf-dist/doc/info"

# bindkey '^ ' expand-or-complete-prefix
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
# bindkey -s '^v' 'nvim $(fzf)\n'
bindkey -s '^[s' 'fzf_ripgrep\n'
bindkey -s '^[f' 'fzf_files\n'

zi snippet "$ZSH_CUSTOM/themes/minimal/minimal.zsh"

# eval "clear"
