if ($args.Count -eq 0) {
    $path = "~"
}
else {
    $path = $args[0]
}
Try {
    $destination = Resolve-Path($path) -ErrorAction Stop
}
Catch {
    Write-Output $(($PWD).Path + "\" + $path + " does not exist...")
    Write-Output "Using home directory instead"
}

$destination | Set-Location && fd | fzf --height 50% | Set-Location
