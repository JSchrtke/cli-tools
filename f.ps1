if ($args.Count -eq 0) {
    $CurrentPath = ($PWD).Path
    $FilePath = $(Resolve-Path ~).Path | cd && & fzf --height 50% --preview 'bat --style=numbers --color=always {} | head -500'
    if ($FilePath) {
        $(Resolve-Path $FilePath).Path
    }
    $CurrentPath | cd
}
else {
    $CurrentPath = ($PWD).Path
    $FilePath = $(Resolve-Path ~).Path | cd && & fzf --height 50% --preview 'bat --style=numbers --color=always {} | head -500'
    if ($FilePath) {
        $(Resolve-Path $FilePath).Path
    }
    $CurrentPath | cd
}
