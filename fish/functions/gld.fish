function gld
  set current_branch $(git rev-parse --abbrev-ref HEAD)
  set upstream_with_color_codes $(gt branch info | rg "Parent" | cut -d " " -f 2 | tr -d '\r')
  set upstream $(echo $upstream_with_color_codes | sed -e 's/\x1b\[[0-9;]*m//g')

  printf "Changes on "

  #set_color -o green
  printf $current_branch
  #set_color normal

  printf " since "

  #set_color -o green
  printf $upstream"\r\n"
  #set_color normal

  git --no-pager log --oneline "$upstream..HEAD"
end
