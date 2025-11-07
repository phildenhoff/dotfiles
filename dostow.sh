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
  # We need to process line by line to handle multiple blocks correctly
  local result=""
  local in_block=false
  local block_condition=""
  local block_content=""

  while IFS= read -r line; do
    # Check for opening tag
    if [[ $line =~ \{\{#IF_HOSTNAME_([^}]+)\}\} ]]; then
      in_block=true
      block_condition="${BASH_REMATCH[1]}"
      block_content=""
      continue
    fi

    # Check for closing tag
    if [[ $line =~ \{\{/IF_HOSTNAME_[^}]+\}\} ]]; then
      if [ "$in_block" = true ]; then
        # If hostname matches, keep the block content
        if [ "$HOSTNAME" = "$block_condition" ]; then
          result+="$block_content"
        fi
        in_block=false
        block_condition=""
        block_content=""
      fi
      continue
    fi

    # Regular line processing
    if [ "$in_block" = true ]; then
      block_content+="$line"$'\n'
    else
      result+="$line"$'\n'
    fi
  done <<< "$content"

  content="$result"

  # Replace all {{VAR}} with values from remaining arguments
  while [ $# -gt 0 ]; do
    local key=$1
    local value=$2
    local placeholder="{{$key}}"
    content="${content//"$placeholder"/$value}"
    shift 2
  done

  printf '%s' "$content" > "$output_file"
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
