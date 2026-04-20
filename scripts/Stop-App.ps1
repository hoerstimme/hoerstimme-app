$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$ComposePath = Join-Path $ProjectRoot "voice_bridge_be"

function Write-Info($Message) {
    Write-Host $Message -ForegroundColor Cyan
}

function Write-Success($Message) {
    Write-Host $Message -ForegroundColor Green
}

function Fail($Message) {
    Write-Host $Message -ForegroundColor Red
    exit 1
}

function Ensure-ComposeFileExists {
    param([string]$Path)

    $files = @(
        "docker-compose.yml",
        "docker-compose.yaml",
        "compose.yml",
        "compose.yaml"
    )

    foreach ($file in $files) {
        if (Test-Path (Join-Path $Path $file)) {
            return
        }
    }

    Fail "ERROR: No Docker Compose file found in $Path"
}

Ensure-ComposeFileExists -Path $ComposePath

Write-Info "Stopping application containers..."
Push-Location $ComposePath
try {
    docker compose down
    if ($LASTEXITCODE -ne 0) {
        Fail "ERROR: docker compose down failed."
    }
}
finally {
    Pop-Location
}

Write-Success "Application stopped successfully."