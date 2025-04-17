# sorry, I use which all the time, but I don't mean /usr/bin/which
alias which=type

# Composing into other functions & commands
alias bat_preview='bat --style=numbers --color=always {}'

# Neovim
# alias nvim='nvim --listen /tmp/nvimsocket'
alias vim=nvim
alias v=nvim

# Some basics

## Use bat to replace cat
alias cat=bat

## Use eza to replace ls
alias ls='eza --icons'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

## Chezmoi
alias cma='chezmoi add'
alias cmp='chezmoi apply'
alias cme="chezmoi edit"
alias cmu="chezmoi update"
alias cmd="chezmoi diff"
alias cmm="chezmoi merge"
alias cmcd="chezmoi cd"

## Replace 'find' with 'fd'
alias find="fd"

alias dush="du -sh"

# Better git aliases
alias ga="git add"
alias gai="git add --interactive"
alias gap="git add --patch"

alias gb="git branch"
alias gbd="git branch --delete"
alias gbD="git branch --delete --force"

alias gco="git checkout"

alias gcl="git clone --recurse-submodules"

alias gc="git commit"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"

alias gd="git diff"
alias gds="git diff --staged"

alias glo="git log --oneline"
alias glon="git log --oneline --no-merges"
alias glos="git log --oneline --show-signature"

alias gp="git push"
# useful when using jj, as no branch is checked out atm
alias gpom="git push origin main"
alias gpnv="git push --no-verify"
alias gpf="git push --force-with-lease"
alias gpfnv="git push --force-with-lease --no-verify"

alias gul="git pull"
alias gulr="git pull --rebase"

alias gst="git status --short --branch"

alias grbi="git rebase -i"
alias grbc="git rebase --continue"

function gpsup
    git push --set-upstream origin $(git symbolic-ref --short HEAD)
end

function glpb
    local upstream
    set upstream_with_color_codes "$(gt b info | rg "Parent" | cut -d " " -f 2 | tr -d '\r')"
    # this SED is macOS specific
    set upstream "$(echo $upstream_with_color_codes | sed -e \$'s/\x1b\[[0-9;]*m//g')"
    git --no-pager log --oneline "$upstream..HEAD"
end

alias pnx="pnpm nx"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias watch="viddy"
