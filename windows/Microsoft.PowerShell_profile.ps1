[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

if (Get-Alias -Name cat -ErrorAction SilentlyContinue) {
    Remove-Item alias:cat
}

if (Get-Alias -Name ls -ErrorAction SilentlyContinue) {
    Remove-Item alias:ls
}

if (Get-Alias -Name gp -ErrorAction SilentlyContinue) {
    Remove-Item -Force alias:gp
}

function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

$EDITOR = if (Test-CommandExists code) { 'code' }
elseif (Test-CommandExists notepad++) { 'notepad++' }
else { 'notepad' }

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

function uptime {
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name = 'LastBootUpTime'; Expression = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
    }
    else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}

function reload-profile { & $profile }
function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | Stop-Process }
function pgrep($name) { Get-Process $name }
function which($name) { Get-Command $name }
function mkcd { param($dir) mkdir $dir -Force; Set-Location $dir }
function touch { param($name) New-Item -ItemType "file" -Path . -Name $name }
function sysinfo { Get-ComputerInfo }

function ls { lsd }
function l { lsd -a }
function a { lsd -la }
function la { lsd -a }
function ll { lsd -la }
function lt { lsd --tree }

function c { Clear-Host }
function cl { Clear-Host }
function cls { Clear-Host }

function home { Set-Location ~ }
function d { Set-Location D:\ }
function e { Set-Location E:\ }
function f { Set-Location C:\Files }
function p { Set-Location C:\Files\Projects }
function repos { Set-Location C:\Files\Repos }

function path { $env:PATH -split ';' | ForEach-Object { "$_" } }
function df { Get-PSDrive -PSProvider FileSystem }
function fe { explorer.exe . }
function cat {
    bat --paging=never --plain --theme='Visual Studio Dark+' @args
}
function edit-profile { code $PROFILE }
function cpy { Set-Clipboard $args[0] }
function pst { Get-Clipboard }
function grep { rg }
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA265 $args }
function pip { python -m pip @args }


function admin {
    if ($args.Count -gt 0) {
        $argList = "& '$args'"
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    }
    else {
        Start-Process wt -Verb runAs
    }
}

function ff {
    $file = fzf --layout=reverse --cycle --border --preview-window=right, 60%, border-left  --height 50% --preview 'bat --style=numbers --color=always --line-range :300 {}'
    if ($file) {
        $extension = [System.IO.Path]::GetExtension($file).ToLower()
        switch ($extension) {
            { $_ -in '.txt', '.md', '.json', '.yml', '.yaml', '.ps1', '.sh', '.py', '.js', '.cpp', '.c', '.haxe', '.hx', '.ts' } {
                & code $file
            }
            { $_ -in '.pdf' } {
                & sumatrapdf $file  
            }
            default {
                Invoke-Item $file
            }
        }
    }
}

function activate {
    $venvDir = Join-Path -Path $PWD -ChildPath ".venv"
    if (-not (Test-Path $venvDir -PathType Container)) {
        Write-Host "No .venv found in the current directory." -ForegroundColor Red
        return
    }

    $activateScript = Join-Path -Path $venvDir -ChildPath "Scripts\Activate.ps1"
    if (-not (Test-Path $activateScript -PathType Leaf)) {
        Write-Host "Virtual environment activation script not found." -ForegroundColor Red
        Write-Host "Expected path: $activateScript" -ForegroundColor Yellow
        return
    }

    & $activateScript
}

function cloc {
    tokei -s lines @args
}

Set-Alias -Name sudo -Value admin


# Git
function gc {
    git commit -m "$args"
}

function xd {
    git add .
    git commit -m "update"
    git push
}

function gp { git push }
function ga { git add . }
function pal { git pull }
function gd { git diff }
function gs { git status -sb }
function gc { git commit }
function gb { git checkout }
function branch { git checkout }
function scoopy { Invoke-FuzzyScoop }

# Fzf
$env:FZF_DEFAULT_OPTS = @"
--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
--color=border:$($Flavor.Surface2)
--layout=reverse
--cycle
--scroll-off=5
--border
--height 70%
--preview-window=right,60%,border-left
--preview 'bat --style=numbers --color=always --line-range :500 {}'
"@

$env:_PSFZF_FZF_DEFAULT_OPTS = @"
--layout=reverse
--cycle
--color=border:$($Flavor.Surface2)
--border
--height 50%
"@

# PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{
    InlinePrediction = "$([char]0x1b)[38;5;238m"
}

Set-PSReadLineKeyHandler -Chord "Ctrl+f" -Function AcceptSuggestion

Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+h'

Set-PSReadLineKeyHandler -Chord 'Ctrl+e' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('ff')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# Oh-my-posh
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1
oh-my-posh init pwsh --config 'C:/Files/Projects/dotfiles/config/ohmyposh.json' | Invoke-Expression
