function fzf_select --argument-names "starting_query"
  fzf --query "$starting_query" --multi --select-1 --exit-0 --preview bat_preview --preview-window right:60%
end
