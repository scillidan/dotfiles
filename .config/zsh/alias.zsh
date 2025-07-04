## fzf
# https://dev.to/helderberto/integrating-tldr-with-fzf-2377
alias tldf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr'

## git
alias zgc='git clone --depth=1 $1 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$2'

## jsc
alias jc='jsc -s "$1" | xargs -n 1 -r aria2'

## multi-git-status
alias mgit="mgitstatus"

## oh-my-zsh-git-plugin-cheatsheet
alias gcheat="${ZSH_CUSTOM}/plugins/oh-my-zsh-git-plugin-cheatsheet/oh-my-zsh-git-plugin-cheatsheet.sh"

## zsh
## zsh-abbr
alias -g ls='eza'

## zsh-exa
eza_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale')
# alias ls='eza $eza_params'
alias l="eza $eza_params"
alias li='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'


alias binln='ln -s "$PWD/$1" $HOME/Usr/Bin/'

