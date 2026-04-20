param (
    [string]$FrontendUrl = "http://127.0.0.1:3000",
    [int]$DockerStartupTimeoutSeconds = 180,
    [int]$FrontendStartupTimeoutSeconds = 180
)

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

function Get-DockerDesktopExe {
    $candidates = @(
        (Join-Path $Env:ProgramFiles "Docker\Docker\Docker Desktop.exe"),
        (Join-Path ${Env:ProgramFiles(x86)} "Docker\Docker\Docker Desktop.exe")
    ) | Where-Object { $_ -and (Test-Path $_) }

    return $candidates | Select-Object -First 1
}

function Start-DockerDesktop {
    $dockerExe = Get-DockerDesktopExe
    if (-not $dockerExe) {
        Fail "ERROR: Docker Desktop not found."
    }

    Write-Info "Starting Docker Desktop..."
    Start-Process -FilePath $dockerExe | Out-Null
}

function Wait-ForDocker {
    param([int]$TimeoutSeconds)

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
            Fail "ERROR: Docker did not become ready within timeout."
        }

        Start-Sleep -Seconds 3
    }
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

function Wait-ForUrl {
    param(
        [string]$Url,
        [int]$TimeoutSeconds
    )

    $startTime = Get-Date

    while ($true) {
        try {
            $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500) {
                Write-Success "Frontend is reachable: $Url"
                return
            }
        } catch {}

        if ((Get-Date) - $startTime -gt [TimeSpan]::FromSeconds($TimeoutSeconds)) {
            Fail "ERROR: Frontend did not become reachable within timeout: $Url"
        }

        Start-Sleep -Seconds 2
    }
}

Ensure-ComposeFileExists -Path $ComposePath

if (-not (Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue)) {
    Start-DockerDesktop
}

Wait-ForDocker -TimeoutSeconds $DockerStartupTimeoutSeconds

Write-Info "Starting application containers..."
Push-Location $ComposePath
try {
    docker compose up -d
    if ($LASTEXITCODE -ne 0) {
        Fail "ERROR: docker compose up -d failed."
    }
}
finally {
    Pop-Location
}

Wait-ForUrl -Url $FrontendUrl -TimeoutSeconds $FrontendStartupTimeoutSeconds

Write-Info "Opening browser..."
Start-Process $FrontendUrl | Out-Null

Write-Success "Application started successfully."