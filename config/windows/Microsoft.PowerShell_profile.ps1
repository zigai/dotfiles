[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

foreach ($alias in @('cat', 'ls', 'gp', 'pwd')) {
    if (Get-Alias -Name $alias -ErrorAction SilentlyContinue) {
        Remove-Item -Force alias:$alias
    }
}

function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

$EDITOR = if (Test-CommandExists code) { 'code' }
elseif (Test-CommandExists notepad++) { 'notepad++' }
else { 'notepad' }

if (Test-CommandExists 'bat') {
    function cat {
        & bat --paging=never --plain --theme='Visual Studio Dark+' @args
    }
}
else {
    function cat {
        Get-Content @args
    }
}

function touch { param($name) New-Item -ItemType "file" -Path . -Name $name }

function uptime {
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name = 'LastBootUpTime'; Expression = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
    }
    else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}

function pwd {
    $currentPath = Get-Location
    $pathString = $currentPath.Path
    Write-Host $pathString
    Set-Clipboard $pathString
}

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $PWD)
    $fullFile = Get-ChildItem -Path $PWD -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $PWD
}

function sysinfo { Get-ComputerInfo }
function path { $env:PATH -split ';' | ForEach-Object { "$_" } }
if (Test-CommandExists 'duf') {
    function df { & duf @args }
}
else {
    function df { Get-PSDrive -PSProvider FileSystem }
}

function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | Stop-Process }
function pgrep($name) { Get-Process $name }
function which($name) { Get-Command $name }


if (Test-CommandExists 'lsd') {
    function ls { & lsd @args }
    function l { & lsd -a @args }
    function a { & lsd -la @args }
    function la { & lsd -a @args }
    function ll { & lsd -la @args }
    function lt { & lsd --tree @args }
}
else {
    function ls { Get-ChildItem @args }
    function l { Get-ChildItem -Force @args }
    function a { Get-ChildItem -Force @args }
    function la { Get-ChildItem -Force @args }
    function ll { Get-ChildItem -Force @args }
    function lt { Get-ChildItem -Recurse @args }
}

function home { Set-Location ~ }
function d { Set-Location D:\ }
function e { Set-Location E:\ }
function f { Set-Location C:\Files }
function p { Set-Location C:\Files\Projects }
function repos { Set-Location C:\Files\Repos }
function .. { Set-Location .. }
function ... { Set-Location ..//.. }
function mkcd { param($dir) mkdir $dir -Force; Set-Location $dir }

function c { Clear-Host }
function cl { Clear-Host }
function cls { Clear-Host }

function cpy { Set-Clipboard $args[0] }
function pst { Get-Clipboard }

function md5 { Get-FileHash -Algorithm MD5 @args }
function sha1 { Get-FileHash -Algorithm SHA1 @args }
function sha256 { Get-FileHash -Algorithm SHA256 @args }

function pip { python -m pip @args }
function ipy { ipython @args }
if (Test-CommandExists 'tokei') {
    function cloc { & tokei -s lines @args }
}
elseif (-not (Test-CommandExists 'cloc')) {
    function cloc { Write-Warning 'Neither tokei nor cloc is installed.' }
}

function grep {
    if (Test-CommandExists 'rg') {
        & rg @args
    }
    else {
        Select-String @args
    }
}

if (Test-CommandExists 'btop') {
    function htop { & btop @args }
}
elseif (-not (Test-CommandExists 'htop')) {
    function htop { Write-Warning 'Neither btop nor htop is installed.' }
}
function scoop-ui { Invoke-FuzzyScoop @args }

function reload-profile { & $profile }
function edit-profile { code $PROFILE }
function vscode-settings { code "$env:APPDATA\Code\User\settings.json" }
function wt-settings { code "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" }

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

function gc { git commit -m @args }
function gp { git push @args }
function ga { git add . @args }
function pal { git pull @args }
function gd { git diff @args }
function gs { git status -sb @args }
function gb { git checkout @args }
function branch { git checkout @args }

function xd {
    git add .
    git commit -m "update"
    git push
}

Set-Alias -Name sudo -Value admin

# FZF 
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
