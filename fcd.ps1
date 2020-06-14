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

$destination = $PWD
$fzfOutput = $($startingDir | Set-Location && fd | fzf --height 50%)
if ($fzfOutput) {
    $destination = $fzfOutput
}
if (!($destination | Test-Path -PathType Container)) {
    $destination = [System.IO.Path]::GetDirectoryName($destination)
}
$destination | Set-Location