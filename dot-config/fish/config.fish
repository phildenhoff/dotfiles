set --export NNN_PLUG 'p:pd-preview'

if string match -q -- $hostname press
    fish_add_path /run/current-system/sw/bin
    fish_add_path /opt/homebrew/bin/brew
end

# Commands to run in interactive sessions can go in here
if status is-interactive
    if string match -q -- $hostname carafe whisk
        env SHELL=fish /opt/homebrew/bin/brew shellenv | source
    end

    # ENVVAR stuff
    # Use our Helix wrapper script that pulls the theme from the macos system settings
    set --export EDITOR "$HOME/.local/bin/hx"
    set --export FZF_DEFAULT_COMMAND 'fd --type file --strip-cwd-prefix'
    set --export FZF_CTRL_T_COMMAND 'fd --follow --exclude .git --exclude node_modules'

    set --export XDG_CACHE_HOME "$HOME/.cache"
    set --export XDG_DATA_HOME "$HOME/.local/share"
    set --export XDG_CONFIG_HOME "$HOME/.config"
    set --export XDG_STATE_HOME "$HOME/.local/state"
    set --export XDG_RUNTIME_DIR $TMPDIR

    if string match -q -- $hostname carafe whisk
        # iTerm2
        source ~/.iterm2_shell_integration.fish
    end

    # Add Starship prompt
    starship init fish | source

    if string match -q -- $hostname carafe whisk
        # fnm is a faster version of nvm
        eval "$(fnm env --use-on-cd --shell=fish)"
    end

    # Bun
    set --export BUN_INSTALL $XDG_STATE_HOME/bun
    fish_add_path $BUN_INSTALL/bin

    # Moon
    fish_add_path $XDG_STATE_HOME/moon/bin

    # xdg-ninja fixes for XDG folders
    ## Cargo
    set --export CARGO_HOME $XDG_DATA_HOME/cargo
    ## Docker
    set --export DOCKER_CONFIG $XDG_CONFIG_HOME/docker
    ## Gem
    set --export GEM_HOME $XDG_DATA_HOME/gem
    ## Gem specs
    set --export GEM_SPEC_CACHE $XDG_CACHE_HOME/gem
    ## GnuPG
    set --export GNUPGHOME $XDG_DATA_HOME/gnupg
    ## Gradle
    set --export GRADLE_USER_HOME $XDG_DATA_HOME/gradle
    ## Less
    set --export LESSHISTFILE $XDG_STATE_HOME/less/history
    ## Node
    set --export NODE_REPL_HISTORY $XDG_DATA_HOME/node_repl_history
    ## Pyenv
    set --export PYENV_ROOT $XDG_DATA_HOME/pyenv
    ## Bundle
    set --export BUNDLE_USER_CONFIG $XDG_CONFIG_HOME/bundle
    set --export BUNDLE_USER_CACHE $XDG_CACHE_HOME/bundle
    set --export BUNDLE_USER_PLUGIN $XDG_DATA_HOME/bundle

    ## Rustup
    set --export RUSTUP_HOME $XDG_DATA_HOME/rustup
    ## Rust
    fish_add_path -m $XDG_DATA_HOME/.local/share/cargo/bin

    # Trying to get nnn to display images (catimg alias)
    fish_add_path -m ~/.local/bin
    fish_add_path -m ~/.iterm2

    # jj is a Git-compatible DVCS
    # Add branch suggestion to `jj branch set` and `jj git push -b`
    complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from set" -f -a "(git branch --format='%(refname:short)')"
    function jgp
        jj git push -b $argv --allow-new
    end
    function __fish_jgp_branches
        # This function will simply list git branches, formatted for completion
        git branch --format='%(refname:short)'
    end
    complete --command jgp -A --no-files --condition __fish_use_subcommand --arguments '(__fish_jgp_branches)' -d 'Branch name'

    jj util completion fish | source

    # 1Password SSH auth socket so that libssh2 programs (like jj) can use
    # 1P for SSH auth
    set --export SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

    # Cargo
    fish_add_path $XDG_DATA_HOME/cargo/bin

    # Add atuin for shared command histories
    atuin init fish --disable-up-arrow | source

    # Add zoxide, a better cd
    zoxide init fish | source

    # Move Wakatime to the XDG_CONFIG directory, instead of being in $HOME
    set --export WAKATIME_HOME "$XDG_CONFIG_HOME/wakatime"
end

if string match -q -- $hostname carafe whisk
    # pnpm
    set -gx PNPM_HOME $HOME/Library/pnpm
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
    # pnpm end

    # Dec 28, 2024 This is a hack and I'm sorry about it
    fish_add_path /nix/store/msgwpjsr2607nmlm4f0klc60m7vyp2ls-git-2.46.0/bin/

    # Added by OrbStack: command-line tools and integration
    # This won't be added again if you remove it.
    source ~/.orbstack/shell/init2.fish 2>/dev/null || :
end

if string match -q -- $hostname whisk
    # wasmtime was added for Orbit's focus on Shopify Functions. It may not be necessaryk1
    set -gx WASMTIME_HOME "$HOME/.wasmtime"

    string match -r ".wasmtime" "$PATH" >/dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH

    # pnpm
    set -gx PNPM_HOME $HOME/Library/pnpm
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
    # pnpm end
end

if string match -q -- $hostname knife
    if status is-login
        # if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" -eq 1
        #     dbus-run-session Hyprland
        # end
    end
end
