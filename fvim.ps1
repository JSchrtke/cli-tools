if ($args.Count -eq 0) {
    $UserPath = "~"
}
else {
    $UserPath = $args[0]
}

$CurrentPath = ($PWD).Path
$FilePath = $(Resolve-Path $UserPath).Path | cd && & fzf --height 50% --preview 'bat --style=numbers --color=always {} | head -500'
if ($FilePath) {
    vim $FilePath
}
$CurrentPath | cd
