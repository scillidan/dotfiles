# ~/.bashrc

export LANG="en_US.UTF-8"
export USER=$(id -un)
export EDITOR="nvim"
export BROWSER="qutebrowser"

# export USERHOME="<user_home>"
if [[ $OSTYPE == msys* || $OSTYPE == cygwin* ]]; then
  # Windows (MSYS/Cygwin): システム環境の USERHOME (例: E:) を MSYS パス (/e) に変換
  if [[ $USERHOME == [A-Za-z]:* ]]; then
    USERHOME=$(cygpath -u -- "$USERHOME")
  fi
fi
export USERHOME

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

source $USERHOME/Local/Source/bash/bash-completion/bash_completion
source $USERHOME/Local/Source/bash/ble.sh/out/ble.sh

eval "$(atuin init bash --disable-up-arrow)"

# export CARAPACE_BRIDGES="bash"
# source <(carapace _carapace)

export FZF_DEFAULT_OPTS="--bind='alt-p:preview-page-up,alt-n:preview-page-down,tab:select+down,btab:deselect+down,ctrl-a:select-all,ctrl-d:deselect-all'"
eval "$(fzf --bash)"

eval "$(zoxide init bash)"

source "$USERHOME/Share/dotfiles/.config/bash/load-aliases.bash"
load_yaml_file "$USERHOME/Share/dotfiles/.config/alias.yaml"
load_yaml_file "$USERHOME/Share/dotfiles/.config/alias-scripts.yaml"
source "$USERHOME/Share/dotfiles/.config/bash/functions.bash"

export HF_MIRROR="https://hf-mirror.com"
export HF_ENDPOINT="https://hf-mirror.com"
export INFOPATH="$TEXLIVE/texmf-dist/doc/info"

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

bind '"\C-@": complete'
bind '"\e[H": beginning-of-line'
bind '"\e[F": end-of-line'
bind '"\e[3~": delete-char'
bind -x '"\ef": fzf_files'
bind -x '"\eg": fzf_ripgrep'

# eval "clear"
