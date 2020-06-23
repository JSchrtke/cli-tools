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
    Write-Output $(($PWD).Path + "\" + $path + " does not exist...")
    Write-Output "Using home directory instead"
}

$originalDir = ($PWD).Path

$fzfOutput = $($startingDir | Set-Location && fd | fzf --height 50% --preview 'bat --style=numbers --theme=ansi-dark --color=always {} | head -500')
if ($fzfOutput) {
    if (($fzfOutput | Test-Path -PathType Container)) {
        explorer $fzfOutput
    }
    else {
        start $fzfOutput
    }
}

$originalDir | Set-Location
