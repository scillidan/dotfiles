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

