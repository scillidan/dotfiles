load_yaml_file() {
	local file=$1
	local key val body
	while IFS=':' read -r key val || [ -n "$key" ]; do
		key="${key#"${key%%[![:space:]]*}"}"
		key="${key%"${key##*[![:space:]]}"}"
		[[ -z "$key" || "$key" =~ ^# ]] && continue
		val="${val# }"
		if [[ "$val" == *'$'* ]]; then
			body="${val//\$\*/\"\$@\"}"
			eval "function $key() { $body; }"
		else
			alias "$key=$val"
		fi
	done <"$file"
}
