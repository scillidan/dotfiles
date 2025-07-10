export $(dbus-launch)
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export EDITOR="nvim"

## zsh-env-secrets
ENV_SECRETS=(
  "TENCENT_SECRET_ID"
  "TENCENT_SECRET_KEY"
  "OPENAI_API_KEY"
  "OPENROUTER_API_KEY"
)
ENV_SECRETS_BACKEND="pass"
ENV_SECRETS_QUIET=1

