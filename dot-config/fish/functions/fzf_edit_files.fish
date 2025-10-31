function vf
  set previewer bat_preview
  set files (fzf_select)

  if test -n "$files"
    echo "$EDITOR \"$files\""
    print -s "$EDITOR \"$files\""
    eval $EDITOR "$files"
  end
end
