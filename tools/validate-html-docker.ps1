param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths = @('index.html')
)

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker not found in PATH. Install Docker Desktop or the docker CLI and retry."
    exit 2
}

$pwd = (Get-Location).Path
$allMessages = @()
foreach ($p in $Paths) {
    if (-not (Test-Path $p)) {
        Write-Error "File not found: $p"
        exit 3
    }
    Write-Output "Validating $p via Docker vnu"
    $outFile = [System.IO.Path]::GetTempFileName()
    $cmd = "docker run --rm -v \"$pwd:/workspace\" validator/validator:latest --format json /workspace/$p > \"$outFile\""
    iex $cmd
    try {
        $json = Get-Content $outFile -Raw | ConvertFrom-Json
    } catch {
        Write-Error "Failed to parse vnu output for $p"
        Remove-Item $outFile -Force
        exit 4
    }
    if ($json.messages) { $allMessages += $json.messages }
    Remove-Item $outFile -Force
}

if ($allMessages.Count -gt 0) {
    Write-Error "HTML validation found $($allMessages.Count) message(s) (errors + warnings)."
    $groups = $allMessages | Group-Object -Property type
    foreach ($g in $groups) {
        Write-Output "Type: $($g.Name) — $($g.Count)"
        foreach ($m in $g.Group) {
            $loc = ''
            if ($m.lastLine) { $loc = "$($m.lastLine):$($m.lastColumn)" }
            Write-Output " - [$loc] $($m.message)"
        }
    }
    exit 1
} else {
    Write-Output "No HTML validation messages."
    exit 0
}