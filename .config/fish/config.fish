set --export NNN_PLUG 'p:pd-preview'

# Commands to run in interactive sessions can go in here
if status is-interactive
    if string match -q -- $hostname carafe
        env SHELL=fish /opt/homebrew/bin/brew shellenv | source
    end

    # ENVVAR stuff
    set --export EDITOR hx
    set --export FZF_DEFAULT_COMMAND 'fd --type file --strip-cwd-prefix'
    set --export FZF_CTRL_T_COMMAND 'fd --follow --exclude .git --exclude node_modules'

    if string match -q -- $hostname carafe
        set --export XDG_CACHE_HOME '/Users/phil/.cache'
        set --export XDG_DATA_HOME '/Users/phil/.local/share'
        set --export XDG_CONFIG_HOME '/Users/phil/.config'
        set --export XDG_STATE_HOME '/Users/phil/.local/state'
        set --export XDG_RUNTIME_DIR $TMPDIR
    end

    if string match -q -- $hostname carafe
        # iTerm2
        source ~/.iterm2_shell_integration.fish
    end

    # Add Starship prompt
    starship init fish | source

    # fnm is a faster version of nvm
    eval "$(fnm env --use-on-cd --shell=fish)"

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
        jj git push -b $argv
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
end


# pnpm
if string match -q -- $hostname carafe
    set -gx PNPM_HOME /Users/phil/Library/pnpm
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
    # pnpm end
    fish_add_path /Users/phil/.spicetify
end
