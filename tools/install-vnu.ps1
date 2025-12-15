param(
    [string]$InstallDir = "$PSScriptRoot/../.vnu"
)

if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Error "Java not found in PATH. Install a JRE (OpenJDK) and re-run this script."
    exit 2
}

if (-not (Test-Path -Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

$jarPath = Join-Path $InstallDir 'vnu.jar'
$url = 'https://github.com/validator/validator/releases/latest/download/vnu.jar'

Write-Output "Downloading vnu.jar to $jarPath"
try {
    Invoke-WebRequest -Uri $url -OutFile $jarPath -UseBasicParsing -ErrorAction Stop
    Write-Output "Downloaded vnu.jar"
} catch {
    Write-Error "Failed to download vnu.jar: $_"
    exit 3
}

Write-Output "Installation complete. Run: .\tools\validate-html.ps1 <file.html>"