#!/usr/bin/env bash
# Install, update, or report zjstatus.wasm used by layouts/minimal.kdl.
#
#   install-zjstatus.sh          install/update the latest release
#   install-zjstatus.sh --check  print what is installed
#
# Skips the download when the recorded version already matches the latest
# release, so running it on every setup only costs one API request.
#
# Env overrides:
#   ZJSTATUS_REPO   default dj95/zjstatus
#   ZJSTATUS_PROXY  optional https:// prefix for github.com downloads
#                   (the release asset host is unreachable on some networks)

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
plugin_dir="${here}/../plugins"
plugin="${plugin_dir}/zjstatus.wasm"
repo="${ZJSTATUS_REPO:-dj95/zjstatus}"
proxy="${ZJSTATUS_PROXY:-}"

if [ "${1:-}" = "--check" ]; then
  echo "${plugin}: $(wc -c <"${plugin}" | tr -d ' ') bytes"
  exit 0
fi

mkdir -p "${plugin_dir}"

latest="$(curl -fsSL --retry 3 "https://api.github.com/repos/${repo}/releases/latest" |
  grep -o '"tag_name": *"[^"]*"' | head -1 | cut -d'"' -f4)"
echo "latest ${repo} release: ${latest}"

if grep -qx "version = ${latest}" "${plugin}.version" 2>/dev/null; then
  echo "${plugin} is up to date, skipping"
  exit 0
fi

url="https://github.com/${repo}/releases/download/${latest}/zjstatus.wasm"
if [ -n "${proxy}" ]; then
  url="${proxy}${url}"
  echo "using proxy: ${proxy}"
fi

curl -fL --retry 3 -o "${plugin}.tmp" "${url}"
mv "${plugin}.tmp" "${plugin}"
echo "version = ${latest}" >"${plugin}.version"
echo "installed ${latest}"
