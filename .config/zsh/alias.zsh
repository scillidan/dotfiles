### archwsl
# alias syncnvim='rsync -r ~/.config/nvim/ /mnt/c/Users/User/AppData/Local/nvim --include={".*"} --exclude="lazy-lock.json"'

# asciinema
alias play='asciinema play'
alias rec='asciinema rec'

## fzf
# https://dev.to/helderberto/integrating-tldr-with-fzf-2377
alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr'

## deep-translator
alias tez='deep-translator --translator tencent --source "en" --target "zh" --text'

## dictd
alias dec='sdcv --color --data-dir=$HOME/Usr/File/file_sdcv --use-dict=ecdict'

## jsc
alias jc='jsc -s "$1" | xargs -n 1 -r aria2'

## sdcv
alias sdec='dict -d ecdict'

## trashy
alias rm='trash'

## zsh-abbr
# alias -g ls='eza'

## zsh-exa
eza_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale')
alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'

## zellij
alias zw='zellij --layout=swap'

alias zgc='git clone --depth=1 $1 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$2'
alias gc='git clone --depth=1'
alias binln='ln -s "$PWD/$1" $HOME/Usr/Bin/'
alias binrm='rm $HOME/Usr/bin/$1'

