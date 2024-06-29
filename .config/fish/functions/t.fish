function t --argument prefix
    set dir (mktemp -d /tmp/$prefix.XXXX)
    pushd $dir
end
