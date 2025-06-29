export $(dbus-launch)
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export EDITOR="nvim"

## termux
# export TERMUX_ROOT="/data/data/com.termux/files"
# export TERMUX_HOME="/storage/emulated/0/Download"

## fzf
# export FZF_CTRL_T_COMMAND=""
# export FZF_DEFAULT_COMMAND=""
# export ENHANCD_FILTER="fzy:fzf --height 40%"

## ollama
export OLLAMA_HOST="100.111.134.102"
export OLLAMA_ORIGINES="*"

## org-hopper
# export ORG_HOPPER_ORG=clockworkpi
# export ORG_HOPPER_CACHE_LOCATION="$HOME/Usr/"
# export ORG_HOPPER_REPO_DIRECTORY="$HOME/Usr/Org/$ORG_HOPPER_ORG"
# export ORG_HOPPER_COLOR_RECENT=cyan
# export ORG_HOPPER_COLOR_OUTDATED=red

## sdcv
export STARDICT_DATA_DIR="$HOME/Usr/File/File_sdcv"

## neovim
### rime-ls
export LIBRIME_LIB_DIR="$HOME/.local/lib/rime/dist/lib"
export LIBRIME_INCLUDE_DIR="$HOME/.local/lib/rime/dist/include"
export LIB="$HOME/.local/lib/rime/dist/lib"

## texlive
export INFOPATH="$TEXLIVE/texmf-dist/doc/info"
export MANPATH="$TEXLIVE/texmf-dist/doc/man"
export TEXLIVE="/usr/local/texlive/2025"

## zellij
export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"
export ZELLIJ_CONFIG_FILE="$HOME/.config/zellij/user.kdl"

## zsh
export ZSH_DOTFILES="$HOME/.config/zsh"

### zsh-smart-insert
export ZSH_SMART_INSERT_PREFIXES="nvim:subl:less"
export ZSH_SMART_INSERT_IGNOREDIRS=".git/*:node_modules/:dist/:.venv/:public/:site/"

### zsh-env-secrets
ENV_SECRETS=(
  "TENCENT_SECRET_ID"
  "TENCENT_SECRET_KEY"
  "OPENAI_API_KEY"
  "OPENROUTER_API_KEY"
)
ENV_SECRETS_BACKEND="pass"
ENV_SECRETS_QUIET=1

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/Usr/Script/.venv/bin:$HOME/Usr/Lib/lua51/bin:$HOME/.tmuxifier/bin:$TEXLIVE/bin/x86_64-linux:$PATH"

