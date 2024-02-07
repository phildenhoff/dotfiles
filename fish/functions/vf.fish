function vf
  set previewer bat_preview
  set files (fzf_select)

  if test -n "$files"
    $EDITOR $files
    echo "$EDITOR \"$files\""
  end
end
