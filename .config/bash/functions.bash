# https://junegunn.github.io/fzf/tips/ripgrep-integration
fzf_ripgrep() {
	set -euo pipefail

	local RELOAD='reload:rg --hidden --column --color=always --smart-case {q} || :'
	local OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
								nvim {1} +{2}
						 else
								local cmds=()
								while read -r line; do
									local file=$(echo "$line" | cut -d: -f1)
									local lineno=$(echo "$line" | cut -d: -f2)
									cmds+=( "+call cursor($lineno,1)" "$file" )
								done < <(cat {+f})
								nvim "${cmds[@]}"
						 fi'
	fzf --disabled --ansi --multi \
		--border none --preview-border none --no-scrollbar --no-separator \
		--bind "start:$RELOAD" --bind "change:$RELOAD" \
		--bind "enter:become:$OPENER" \
		--bind "ctrl-e:execute:$OPENER" \
		--bind 'ctrl-u:preview-up,ctrl-d:preview-down,alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
		--delimiter : \
		--preview 'bat -n --theme=base16 --color=always --highlight-line {2} {1}' \
		--preview-window '~1,+{2}+4/3,<80(up)' \
		--query "$*"
}
