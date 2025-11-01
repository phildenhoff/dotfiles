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

  # Process conditional blocks {{#IF_HOSTNAME_name}}...{{/IF_HOSTNAME_name}}
  # Only keeps content if HOSTNAME matches
  while [[ $content =~ \{\{#IF_HOSTNAME_([^}]+)\}\}(.*)\{\{/IF_HOSTNAME_[^}]+\}\} ]]; do
    local condition="${BASH_REMATCH[1]}"
    local block_content="${BASH_REMATCH[2]}"
    local full_match="${BASH_REMATCH[0]}"

    if [ "$HOSTNAME" = "$condition" ]; then
      # Keep the content (without the conditional tags)
      content="${content//"$full_match"/$block_content}"
    else
      # Remove the entire block
      content="${content//"$full_match"/}"
    fi
  done

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

# Render jj config
if [ -f "dot-jjconfig.toml.template" ]; then
  echo "Rendering jj config..."

  render_template \
    "dot-jjconfig.toml.template" \
    "dot-jjconfig.toml"

  echo "✔︎ JJ config rendered"
fi

# Run stow
stow --dotfiles --dir="$HOME/.config/_dotfiles" --target="$HOME" .
