## archwsl
# alias syncnvim='rsync -r ~/.config/nvim/ /mnt/c/Users/User/AppData/Local/nvim --include={".*"} --exclude={"lazy-lock.json"}'

## abbreviate
alias abbr='abbreviate original'

## asciinema
alias play='asciinema play'
alias rec='asciinema rec'

## clamav
alias scan='clamscan -v -a --max-filesize=1000M --max-scansize=1000M --alert-exceeds-max=yes'

## deep-translator
#alias c2e='deep-translator --translator google --source "en" --target "zh-CN" --text'
#alias e2c='deep-translator --translator google --source "zh-CN" --target "en" --text'
alias dtc2e='deep-translator --translator tencent --source "en" --target "zh" --text'
alias dte2c='deep-translator --translator tencent --source "zh" --target "en" --text'

## dict
alias ecdict='dict --host ubuntu22 --port 2528 -d ecdict'

## erdtree
alias erd='erd --color auto --hidden --follow --human --disk-usage line --sort name --dir-order first --layout inverted'

## fzf
# https://dev.to/helderberto/integrating-tldr-with-fzf-2377
alias tldf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr'

## gh
alias ghtd='gh tidy'
alias ghdl='gh download'
alias ghco='gh clone-org'

## git
alias gc='git clone --depth=1'

## gopencc
alias t2c='gopencc -c t2s -i'
alias c2t='gopencc -c s2t -i'

## jq
alias jqp='jq ".scripts" ./package.json'

## multi-git-status
alias mgit='mgitstatus'

## pylanguagetool
alias chk='pylanguagetool --api-url http://ubuntu22:8040/v2/ --input-type html --lang en-US -c'

## sdcv
alias de2c='sdcv --color --use-dict=JianMingYingHanZiDian'
alias dc2e='sdcv --color --use-dict=JianMingYingHanZiDian'

## yay
alias yas='yay -S --noconfirm'

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


