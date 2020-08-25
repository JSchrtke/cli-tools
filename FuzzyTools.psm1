function FuzzyFind {
    $prefilter = ""
    if ($args.Count -eq 0) {
        $path = "~"
    }
    elseif ($args[0] -eq "-a") {
        $hidden = "-uu"
        $path = $args[1]
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

    $prev = 'bat --style=numbers --theme=ansi-dark --color=always {} | head -500'
    $fzfOutput = $(
        $startingDir |
        Set-Location && fd.exe $hidden $prefilter |
        fzf.exe --height 90% --layout reverse --border rounded  --preview $prev
    )
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
        nvim $fuzzyOutput
    }

    $originalDir | Set-Location
}

New-Alias -Name fvi -Value FuzzyOpenVim
