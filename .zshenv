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
export OLLAMA_HOST="revios"
export OLLAMA_ORIGINES="*"

## sdcv
export STARDICT_DATA_DIR="$HOME/Usr/File/file_sdcv"

## neovim
### rime-ls
export LIBRIME_LIB_DIR="$HOME/.local/lib/rime/dist/lib"
export LIBRIME_INCLUDE_DIR="$HOME/.local/lib/rime/dist/include"
export LIB="$HOME/.local/lib/rime/dist/lib"

## texlive
export INFOPATH="$TEXLIVE/texmf-dist/doc/info"
export MANPATH="$TEXLIVE/texmf-dist/doc/man"
export TEXLIVE="/usr/local/texlive/2025"

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

# export $HOME/Usr/Script/.venv/bin
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/go/bin:$HOME/Usr/Lib/lua51/bin:$HOME/.tmuxifier/bin:$TEXLIVE/bin/x86_64-linux:$PATH"

