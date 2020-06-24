$prefilter = ""
if ($args.Count -eq 0) {
    $path = "~"
}
else {
    $path = $args[0]
}
Try {
    $startingDir = Resolve-Path($path) -ErrorAction Stop
}
Catch {
    $prefilter = $path
}

$originalDir = ($PWD).Path

$fzfOutput = $($startingDir | Set-Location && fd $prefilter | fzf --height 50% --preview 'bat --style=numbers --theme=ansi-dark --color=always {} | head -500')
if ($fzfOutput) {
    code $fzfOutput
}

$originalDir | Set-Location