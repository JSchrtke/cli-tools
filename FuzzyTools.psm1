function Find($arguments) {
    $prefilter = ""
    if ($arguments.Count -eq 0) {
        $path = "~"
    }
    elseif ($arguments[0] -eq "-a") {
        $hidden = "-uu"
        $path = $arguments[1]
    }
    else {
        $path = $arguments[0]
    }
    Try {
        $startingDir = Resolve-Path -Path $path -ErrorAction Stop
    }
    Catch {
        $prefilter = $path
    }

    $originalDir = $PWD

    $prev = 'bat --style=numbers --theme=ansi-dark --color=always {} | head -500'
    Set-Location $startingDir
    $fzfOutput = $(
        fd.exe $hidden $prefilter |
        fzf.exe --height 90%  --border rounded  --preview $prev
    )
    if ($fzfOutput) {
        $(Resolve-Path $fzfOutput).Path
    }

    Set-Location $originalDir
}

function FuzzyFind {
    Find($args)
}
New-Alias -Name f -Value FuzzyFind

function FuzzySetLocation {
    $destination = Find($args)
    if (!($destination | Test-Path -PathType Container)) {
        $destination = [System.IO.Path]::GetDirectoryName($destination)
    }
    $destination | Set-Location
}

New-Alias -Name fcd -Value FuzzySetLocation

function FuzzyOpen {
    $originalDir = ($PWD).Path

    $fuzzyOutput = Find($args)
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

    $fuzzyOutput = Find($args)
    if ($fuzzyOutput) {
        code $fuzzyOutput
    }

    $originalDir | Set-Location
}

New-Alias -Name fco -Value FuzzyOpenCode

function FuzzyOpenVim {
    $originalDir = ($PWD).Path

    $fuzzyOutput = Find($args)
    if ($fuzzyOutput) {
        nvim $fuzzyOutput
    }

    $originalDir | Set-Location
}

New-Alias -Name fvi -Value FuzzyOpenVim
