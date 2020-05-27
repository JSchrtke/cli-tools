if ($args.Count -eq 0) {
    Invoke-FuzzySetLocation $PWD
}
else {
    Invoke-FuzzySetLocation $args
}
