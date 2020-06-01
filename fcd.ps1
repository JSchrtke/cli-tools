if ($args.Count -eq 0) {
    $path = $(Resolve-Path ~).Path
}
else {
    $path = Resolve-Path($args[0])
}

$path | cd && fd | & fzf --height 50% | cd
