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

$destination = $PWD
$fzfOutput = $($startingDir | Set-Location && fd $prefilter | fzf --height 50%)
if ($fzfOutput) {
    $destination = $fzfOutput
}
if (!($destination | Test-Path -PathType Container)) {
    $destination = [System.IO.Path]::GetDirectoryName($destination)
}
$destination | Set-Location
