function nixrun
    set package $argv[1]
    nix-shell -p $package --command $package
end
