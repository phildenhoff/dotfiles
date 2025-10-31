# set variables for later
set -l commands (gt --get-yargs-completions)
set -l branches "(git branch | tr -d '*' | tr -d ' ')"

# disable file completions for the entire command
complete -c gt -f

# add top-level commands, only if not provided already
complete -c gt -n "not __fish_seen_subcommand_from $commands" -a "$commands"

# add sub-commands for each top-level command
for command in $commands
    set -l options (gt $command --get-yargs-completions)

    complete -c gt -n "__fish_seen_subcommand_from $command" -n "not __fish_seen_subcommand_from $options" -a "$options"
end

# commands that take branches
complete -c gt -x -n "__fish_seen_subcommand_from checkout" -a $branches
complete -c gt -x -n "__fish_seen_subcommand_from delete" -a $branches
complete -c gt -x -n "__fish_seen_subcommand_from onto" -a $branches
complete -c gt -x -n "__fish_seen_subcommand_from track" -a $branches
complete -c gt -x -n "__fish_seen_subcommand_from untrack" -a $branches

# gt downstack get takes remote branches
set -l remoteBranches "(git branch -r | tr -d '*' | tr -d ' ' | sed -e 's/origin\///')"
complete -c gt -x -n "__fish_seen_subcommand_from get" -a $remoteBranches
