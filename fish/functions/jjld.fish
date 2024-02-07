function jjld
  set current_branch $(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)
  set upstream_with_color_codes $(gt b info | rg "Parent" | cut -d " " -f 2 | tr -d '\r')
  set upstream $(echo $upstream_with_color_codes | sed -e 's/\x1b\[[0-9;]*m//g')

  echo "Changes on $current_branch since $upstream"

  jj log -r "$upstream:@"
end
