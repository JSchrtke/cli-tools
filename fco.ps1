if ($args.Count -eq 0) {
    $UserPath = "~"
}
else {
    $UserPath = $args[0]
}

$CurrentPath = ($PWD).Path
$FilePath = $(Resolve-Path $UserPath).Path | Set-Location && & fzf --height 50% --preview 'bat --style=numbers --theme=ansi-dark --color=always {} | head -500'
if ($FilePath) {
    code $FilePath
}
$CurrentPath | Set-Location
