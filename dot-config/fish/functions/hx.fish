function hx --wraps=helix --description "Launch Helix with theme based on system appearance"
    # Create a temporary config file
    set -l temp_config (mktemp)

    # Copy the base config
    cat ~/.config/helix/config.toml > $temp_config

    # Always use dark mode on press
    if string match -q -- $hostname press
        sed -i '' 's/^theme = .*/theme = "catppuccin_mocha"/' $temp_config
    else
        # Detect macOS appearance mode and set appropriate theme
        if defaults read -g AppleInterfaceStyle &>/dev/null
            # Dark mode - use Catppuccin Mocha
            sed -i '' 's/^theme = .*/theme = "catppuccin_mocha"/' $temp_config
        else
            # Light mode - use Catppuccin Latte
            sed -i '' 's/^theme = .*/theme = "catppuccin_latte"/' $temp_config
        end
    end

    # Launch Helix with the temporary config
    command hx --config $temp_config $argv

    # Clean up
    rm $temp_config
end
