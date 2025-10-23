if string match -q -- $hostname press.local
    source "$HOME/.cargo/env.fish"
end
if string match -q -- $hostname carafe
    source "$HOME/.local/share/cargo/env.fish"
end
