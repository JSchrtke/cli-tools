function FuzzyFind {
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

    $originalDir = $PWD

    $fzfOutput = $($startingDir | Set-Location && fd.exe $prefilter | fzf.exe --height 50% --preview 'bat --style=numbers --theme=ansi-dark --color=always {} | head -500')
    if ($fzfOutput) {
        $(Resolve-Path $fzfOutput).Path
    }

    $originalDir | Set-Location
}

New-Alias -Name f -Value FuzzyFind

function FuzzySetLocation {
    $destination = FuzzyFind $args
    if (!($destination | Test-Path -PathType Container)) {
        $destination = [System.IO.Path]::GetDirectoryName($destination)
    }
    $destination | Set-Location
}

New-Alias -Name fcd -Value FuzzySetLocation

function FuzzyOpen {
    $originalDir = ($PWD).Path

    $fuzzyOutput = FuzzyFind $args
    if ($fuzzyOutput) {
        if (($fuzzyOutput | Test-Path -PathType Container)) {
            explorer $fuzzyOutput
        }
        else {
            Start-Process $(Resolve-Path($fuzzyOutput)).ToString()
        }
    }

    $originalDir | Set-Location
}

New-Alias -Name fo -Value FuzzyOpen

function FuzzyOpenCode {
    $originalDir = ($PWD).Path

    $fuzzyOutput = FuzzyFind $args
    if ($fuzzyOutput) {
        code $fuzzyOutput
    }

    $originalDir | Set-Location
}

New-Alias -Name fco -Value FuzzyOpenCode

function FuzzyOpenVim {
    $originalDir = ($PWD).Path

    $fuzzyOutput = FuzzyFind $args
    if ($fuzzyOutput) {
        vim $fuzzyOutput
    }

    $originalDir | Set-Location
}

New-Alias -Name fvi -Value FuzzyOpenVim