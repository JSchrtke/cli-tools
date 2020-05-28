if ($args.Count -eq 0) {
    $CurrentPath = ($PWD).Path
    $FilePath = $(Resolve-Path ~).Path | cd && & fzf --height 50% --preview 'bat --style=numbers --color=always {} | head -500'
    if ($FilePath) {
        vim $FilePath
    }
    $CurrentPath | cd
}
else {
    $CurrentPath = ($PWD).Path
    $FilePath = $(Resolve-Path $args[0]).Path | cd && & fzf --height 50% --preview 'bat --style=numbers --color=always {} | head -500'
    if ($FilePath) {
        vim $FilePath
    }
    $CurrentPath | cd
}
