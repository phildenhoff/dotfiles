#!/usr/bin/env fish

# Update nix-darwin flake and show what changed

set FLAKE_DIR (dirname (status --current-filename))

echo "📦 Updating flake inputs..."
cd $FLAKE_DIR
nix flake update

# Capture current generation before rebuild
set prev_gen (sudo darwin-rebuild --list-generations | awk '{print $1}' | tail -1)

echo ""
echo "🔨 Rebuilding darwin configuration..."
sudo darwin-rebuild switch --flake .#press

if test $status -eq 0
    echo ""
    echo "✨ Build successful! Comparing generations..."
    echo ""

    # Get the new current generation after rebuild
    set curr_gen (sudo darwin-rebuild --list-generations | awk '{print $1}' | tail -1)

    if test -n "$prev_gen" -a -n "$curr_gen" -a "$prev_gen" != "$curr_gen"
        echo "📊 Comparing generation $prev_gen → $curr_gen"
        echo ""
        nix store diff-closures /nix/var/nix/profiles/system-$prev_gen-link /nix/var/nix/profiles/system-$curr_gen-link
    else if test "$prev_gen" = "$curr_gen"
        echo "ℹ️  No changes - same generation ($curr_gen)"
    else
        echo "⚠️  Could not determine generation numbers for comparison"
    end
else
    echo ""
    echo "❌ Build failed. No changes applied."
    exit 1
end
