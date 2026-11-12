# zjstatus is a third-party status bar for Zellij (~4 MB wasm).
# `plugins/` is gitignored, so each machine downloads its own copy.
#
#   just zellij-zjstatus        # install or update to the latest release
#   just zellij-zjstatus-check  # report what is installed
#
# On networks where the release host is unreachable, set ZJSTATUS_PROXY to an
# https:// proxy prefix and rerun.

_default:
    @just --list

zellij-zjstatus:
    bash scripts/install-zjstatus.sh

zellij-zjstatus-check:
    @bash scripts/install-zjstatus.sh --check
