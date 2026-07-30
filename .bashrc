export EDITOR="nvim"
export BROWSER="qutebrowser"
export LANG="en_US.UTF-8"

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# export USERHOME="<user_home>"
export CARGO_HOME="$USERHOME/.cargo"
export CARGO_TARGET_DIR="$USERHOME/.cache/cargo"
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export G_EXPERIMENTAL=true
export G_HOME="$USERHOME/.g"
export GOROOT="$USERHOME/.g/go"
export GOPATH="$USERHOME/.local/go"
export PIPX_HOME="$USERHOME/.pipx"
export PIPX_BIN_DIR="$USERHOME/.local/bin/pipx"

export PATH="$USERHOME/.local/bin:$CARGO_HOME/bin:$GOPATH/bin:$PIPX_BIN_DIR:$PATH"
export PATH="$USERHOME/Share/scripts:$USERHOME/Share/scripts/arch:$PATH"

if [[ -n "$TERMUX_VERSION" ]]; then
  is_termux=1
else
  is_termux=0
fi

if [ "$is_termux" = "0" ]; then
  export STARDICT_DATA_DIR="$USERHOME/Local/Download/sdcv"
  export TEXLIVE="/usr/local/texlive/2025"
  export MANPATH="/usr/share/man:$TEXLIVE/texmf-dist/doc/man:MANPATH"
  export PATH="$TEXLIVE/bin/x86_64-linux:$PATH"
else
  export STARDICT_DATA_DIR="$HOME/storage/downloads/Local/Download/sdcv"
fi

source <(fzf --bash)
export FZF_DEFAULT_OPTS="--bind='alt-p:preview-page-up,alt-n:preview-page-down,tab:select+down,btab:deselect+down,ctrl-a:select-all,ctrl-d:deselect-all'"

# Atuin
eval "$(atuin init bash)"

# Carapace
source <(carapace _carapace bash)

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

export HF_MIRROR="https://hf-mirror.com"
export HF_ENDPOINT="https://hf-mirror.com"
