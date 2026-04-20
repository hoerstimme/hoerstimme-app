param (
    [switch]$NoCache
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ComposePath = Join-Path (Split-Path -Parent $ScriptDir) "voice_bridge_be"

function Write-Info($Message) {
    Write-Host $Message -ForegroundColor Cyan
}

function Write-Success($Message) {
    Write-Host $Message -ForegroundColor Green
}

function Write-ErrorAndExit($Message) {
    Write-Host $Message -ForegroundColor Red
    exit 1
}

function Test-DockerDesktopInstalled {
    $dockerExe1 = Join-Path $Env:ProgramFiles "Docker\Docker\Docker Desktop.exe"
    $dockerExe2 = Join-Path ${Env:ProgramFiles(x86)} "Docker\Docker\Docker Desktop.exe"

    if (Test-Path $dockerExe1) { return $dockerExe1 }
    if (Test-Path $dockerExe2) { return $dockerExe2 }

    return $null
}

function Start-DockerDesktop {
    $dockerExe = Test-DockerDesktopInstalled
    if (-not $dockerExe) {
        Write-ErrorAndExit "ERROR: Docker Desktop not found."
    }

    Write-Info "Starting Docker Desktop..."
    Start-Process -FilePath $dockerExe | Out-Null
}

function Wait-ForDocker {
    param([int]$TimeoutSeconds = 180)

    $startTime = Get-Date

    while ($true) {
        try {
            docker info *> $null
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Docker is ready."
                return
            }
        } catch {}

        if ((Get-Date) - $startTime -gt [TimeSpan]::FromSeconds($TimeoutSeconds)) {
            Write-ErrorAndExit "ERROR: Docker did not become ready within timeout."
        }

        Start-Sleep -Seconds 3
    }
}

function Get-ComposeFile {
    param([string]$Path)

    $files = @(
        "docker-compose.yml",
        "docker-compose.yaml",
        "compose.yml",
        "compose.yaml"
    )

    foreach ($file in $files) {
        $candidate = Join-Path $Path $file
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    Write-ErrorAndExit "ERROR: No Docker Compose file found in $Path"
}

Get-ComposeFile -Path $ComposePath | Out-Null

if (-not (Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue)) {
    Start-DockerDesktop
}

Wait-ForDocker

Write-Info "Building Docker images..."
Push-Location $ComposePath
try {
    if ($NoCache) {
        docker compose build --no-cache
    } else {
        docker compose build
    }

    if ($LASTEXITCODE -ne 0) {
        Write-ErrorAndExit "ERROR: docker compose build failed."
    }
}
finally {
    Pop-Location
}

Write-Success "Setup completed successfully."