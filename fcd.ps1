if ($args.Count -eq 0) {
    $(Resolve-Path ~).Path | cd && fd | & fzf --height 50% | cd
}
else {
    $path = Resolve-Path($args[0])
    $path | cd && fd | & fzf --height 50% | cd
}
