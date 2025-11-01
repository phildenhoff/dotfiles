# Agent Instructions for Dotfiles Repository

This document provides guidance for AI assistants (like Claude) working with this dotfiles repository.

## File Naming Convention

Files and directories that should be symlinked to the home directory use a `dot-` prefix instead of the actual `.` prefix. This allows them to be visible in the repository while being properly hidden when symlinked.

**Examples:**
- `dot-jjconfig.toml` → symlinked as `~/.jjconfig.toml`
- `dot-config/fish/config.fish` → symlinked as `~/.config/fish/config.fish`
- `dot-gitconfig` → symlinked as `~/.gitconfig`

When creating new dotfiles, always use the `dot-` prefix for files and directories that start with `.` in their final location.

## Templating System

### Overview

The `dostow.sh` script includes a bash-based templating system for rendering configuration files that need machine-specific or secret values. This runs during initial setup before fish is fully configured.

### Template Features

#### 1. Variable Substitution

Use `{{VARIABLE_NAME}}` for simple variable replacement:

```toml
api_key = {{WAKATIME_API_KEY}}
```

Pass values to `render_template`:
```bash
render_template \
  "template-file.template" \
  "output-file" \
  "WAKATIME_API_KEY" "$api_key_value"
```

#### 2. Hostname Conditionals

Use `{{#IF_HOSTNAME_name}}...{{/IF_HOSTNAME_name}}` to include content only on specific machines:

```toml
# This works on all machines
[user]
name = "Phil Denhoff"

{{#IF_HOSTNAME_press}}
# This section only appears on the 'press' machine
[signing]
backend = "ssh"
key = "ssh-ed25519 AAAA..."
{{/IF_HOSTNAME_press}}
```

The conditional blocks support any hostname. Content is included only when `hostname -s` matches the specified name.

### Adding New Templates

1. Create your template file with `.template` extension (e.g., `dot-jjconfig.toml.template`)
2. Use `{{VARIABLE}}` for substitutions and `{{#IF_HOSTNAME_name}}...{{/IF_HOSTNAME_name}}` for conditionals
3. Add rendering logic to `dostow.sh` before the `stow` command:

```bash
if [ -f "your-template-file.template" ]; then
  echo "Rendering your config..."

  # Get any secrets if needed
  SECRET_VALUE=$(op read "op://$OP_VAULT/Secret Name/credential")

  render_template \
    "your-template-file.template" \
    "your-output-file" \
    "SECRET_VAR" "$SECRET_VALUE"

  echo "✔︎ Your config rendered"
fi
```

4. Add the generated file to `.gitignore` if it contains secrets

### Examples

**Wakatime config** (`dot-config/wakatime/.wakatime.cfg.template`):
- Uses variable substitution for API key from 1Password
- Generated file is gitignored

**JJ config** (`dot-jjconfig.toml.template`):
- Uses hostname conditionals for SSH signing on work machine
- Base config works on all machines
- Press-specific config only appears on `press` hostname

## Machine-Specific Configuration

The repository currently supports these hostnames:
- `press` - Work machine (uses Employee 1Password vault)
- `carafe` - Personal machine (uses Personal 1Password vault)
- `whisk` - Personal machine (uses Personal 1Password vault)
- `knife` - Personal machine (uses Personal 1Password vault)

When adding new machine-specific config, use hostname conditionals in templates or fish config's `string match -q -- $hostname machine-name` pattern.
