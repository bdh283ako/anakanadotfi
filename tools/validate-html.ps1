param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths = @('index.html')
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$jarPath = Join-Path $scriptDir '..\.vnu\vnu.jar' | Resolve-Path -ErrorAction SilentlyContinue
if (-not $jarPath) {
    Write-Error "vnu.jar not found. Run .\tools\install-vnu.ps1 first to download it."
    exit 2
}
$jarPath = $jarPath.Path

$allMessages = @()
foreach ($p in $Paths) {
    if (-not (Test-Path $p)) {
        Write-Error "File not found: $p"
        exit 3
    }
    Write-Output "Validating $p"
    $outFile = [System.IO.Path]::GetTempFileName()
    $cmd = "java -jar `"$jarPath`" --format json `"$p`" > `"$outFile`""
    iex $cmd
    $json = Get-Content $outFile -Raw | ConvertFrom-Json
    if ($json.messages) {
        $allMessages += $json.messages
    }
    Remove-Item $outFile -Force
}
if ($allMessages.Count -gt 0) {
    Write-Error "HTML validation found $($allMessages.Count) messages"
    $allMessages | ConvertTo-Json -Depth 5 | Write-Output
    exit 1
} else {
    Write-Output "No HTML validation messages."
    exit 0
}