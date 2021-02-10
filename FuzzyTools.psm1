function Find($arguments) {
    $prefilter = ""
    $startingDir = "."

    if ($arguments[0] -eq "-a") {
        $arguments = $arguments[1..($arguments.Length-1)]
        $hidden = "-uu"
    }
    if ($arguments.Length -gt 0) {
        Try {
            $startingDir = $arguments[0]
            if ($arguments.Length -gt 1) {
                $arguments = $arguments[1..($arguments.Length-1)]
                $prefilter = [String]::Join(" ", $arguments)
            }
        } Catch {
            $prefilter = [String]::Join(" ", $arguments)
        }
    }

    $originalDir = $PWD

    Set-Location $startingDir
    $fzfOutput = $(
        fd.exe -E undodir $hidden $prefilter |
        fzf.exe --preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window right:60%:noborder --height 50% --border sharp
    )

    Set-Location $originalDir

    if (!$fzfOutput) {
        $startingDir = ""
    }

    if (($fzfOutput) && ($startingDir)) {
        $fzfOutput = Join-Path $startingDir $fzfOutput
    }

    Return $fzfOutput
}

function FuzzyFind {
    Find($args)
}
New-Alias -Name f -Value FuzzyFind

function FuzzySetLocation {
    $destination = ""
    $destination = Find($args)

    if ($destination) {
        if (!($destination | Test-Path -PathType Container)) {
            $destination = [System.IO.Path]::GetDirectoryName($destination)
        }
        Push-Location -Path $destination
    }
}

New-Alias -Name fcd -Value FuzzySetLocation

function GoBack {
    Pop-Location
}

New-Alias -Name .. -Value GoBack

function FuzzyOpen {
    $originalDir = ($PWD).Path

    $fuzzyOutput = Find($args)
    if ($fuzzyOutput) {
        if ((Test-Path -Path $fuzzyOutput -PathType Container)) {
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

New-Alias -Name fn -Value FuzzyOpenVim
