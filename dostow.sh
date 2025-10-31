#!/bin/bash
set -e

cd "$HOME/.config/_dotfiles"

# Detect hostname
HOSTNAME=$(hostname -s)

# Set 1Password vault paths based on hostname
case "$HOSTNAME" in
  press)
    # Work machine
    OP_VAULT="Employee"
    ;;
  carafe)
    # Home machine
    OP_VAULT="Personal"
    ;;
  *)
    echo "Unknown hostname: $HOSTNAME"
    echo "Please configure vault settings in dostow.sh"
    exit 1
    ;;
esac

render_template() {
  local template_file=$1
  local output_file=$2
  shift 2

  local content
  content=$(cat "$template_file")

  # Replace all {{VAR}} with values from remaining arguments
  while [ $# -gt 0 ]; do
    local key=$1
    local value=$2
    local placeholder="{{$key}}"
    content="${content//"$placeholder"/$value}"
    shift 2
  done

  printf '%s\n' "$content" > "$output_file"
}

# Render wakatime config
if [ -f "dot-config/wakatime/.wakatime.cfg.template" ]; then
  echo "Rendering wakatime config..."

  WAKATIME_API_KEY=$(op read "op://$OP_VAULT/Wakapi API Key/credential")

  render_template \
    "dot-config/wakatime/.wakatime.cfg.template" \
    "dot-config/wakatime/.wakatime.cfg" \
    "WAKATIME_API_KEY" "$WAKATIME_API_KEY"

  echo "✔︎ Wakatime config rendered"
fi

# Run stow
stow --dotfiles --dir="$HOME/.config/_dotfiles" --target="$HOME" .
