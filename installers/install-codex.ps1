[CmdletBinding()]
param(
    [string]$Dest = (Join-Path $HOME ".agents/skills"),

    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Write-Info([string]$Message) {
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warn([string]$Message) {
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Resolve-VersionFromGit([string]$RepoRoot) {
    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitCmd) {
        return $null
    }

    & $gitCmd.Source -C $RepoRoot rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -ne 0) {
        return $null
    }

    $candidates = @(
        (& $gitCmd.Source -C $RepoRoot describe --tags --abbrev=0 --match "v[0-9]*" 2>$null | Select-Object -First 1),
        (& $gitCmd.Source -C $RepoRoot describe --tags --abbrev=0 --match "[0-9]*" 2>$null | Select-Object -First 1),
        (& $gitCmd.Source -C $RepoRoot tag --list "v[0-9]*" --sort=-v:refname 2>$null | Select-Object -First 1),
        (& $gitCmd.Source -C $RepoRoot tag --list "[0-9]*" --sort=-v:refname 2>$null | Select-Object -First 1)
    )

    foreach ($candidate in $candidates) {
        if ($candidate) {
            return ($candidate.Trim() -replace '^v', '')
        }
    }

    return $null
}

function Resolve-VersionFromChangelog([string]$RepoRoot) {
    $changelogPath = Join-Path $RepoRoot "CHANGELOG.md"
    if (-not (Test-Path $changelogPath)) {
        return $null
    }

    foreach ($line in Get-Content -Path $changelogPath) {
        if ($line -match '^## \[([0-9]+\.[0-9]+\.[0-9]+(?:[-+][0-9A-Za-z\.-]+)?)\]') {
            return $Matches[1]
        }
        if ($line -match '^## ([0-9]+\.[0-9]+\.[0-9]+(?:[-+][0-9A-Za-z\.-]+)?)') {
            return $Matches[1]
        }
    }

    return $null
}

function Resolve-CodexBmadVersion([string]$RepoRoot) {
    $gitVersion = Resolve-VersionFromGit -RepoRoot $RepoRoot
    if ($gitVersion) {
        return @{
            Version = $gitVersion
            Source = "git"
        }
    }

    $changelogVersion = Resolve-VersionFromChangelog -RepoRoot $RepoRoot
    if ($changelogVersion) {
        return @{
            Version = $changelogVersion
            Source = "changelog"
        }
    }

    return @{
        Version = "0.0.0-unknown"
        Source = "unknown"
    }
}

function Write-CodexVersionFile(
    [string]$RepoRoot,
    [string]$Version,
    [string]$Source,
    [bool]$DryRunMode
) {
    $versionFile = Join-Path $RepoRoot "skills/bmad-orchestrator/version.yaml"

    if ($DryRunMode) {
        Write-Info "Would write version file: $versionFile (version=$Version source=$Source)"
        return
    }

    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    @(
        "version: `"$Version`"",
        "source: `"$Source`"",
        "updated_at_utc: `"$timestamp`""
    ) | Set-Content -Path $versionFile -Encoding UTF8

    Write-Ok "Wrote version metadata: $versionFile"
}

function Copy-ProjectReadme(
    [string]$RepoRoot,
    [string]$DestPath,
    [bool]$DryRunMode,
    [bool]$ForceMode
) {
    $sourceReadme = Join-Path $RepoRoot "README.md"
    $targetReadme = Join-Path $DestPath "bmad-README.md"

    if (-not (Test-Path $sourceReadme)) {
        throw "Project README not found: $sourceReadme"
    }

    if ((Test-Path $targetReadme) -and (-not $ForceMode)) {
        Write-Warn "Project README exists, skipping: $targetReadme"
        return
    }

    if ($DryRunMode) {
        if (Test-Path $targetReadme) {
            Write-Info "Would overwrite project README -> $targetReadme"
        }
        else {
            Write-Info "Would copy project README -> $targetReadme"
        }
        return
    }

    Copy-Item -Path $sourceReadme -Destination $targetReadme -Force
    Write-Ok "Copied project README: $targetReadme"
}

function Test-RuntimeRequirements {
    $yqCmd = Get-Command yq -ErrorAction SilentlyContinue
    if (-not $yqCmd) {
        throw "yq not found in PATH. Install yq v4+ before running installer."
    }

    $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
    if (-not $pythonCmd) {
        $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    }
    if (-not $pythonCmd) {
        throw "python not found in PATH. Install python3 before running installer."
    }

    $yqVersion = (& yq --version 2>$null)
    $pythonVersion = (& $pythonCmd.Source --version 2>&1)

    if (-not $yqVersion) {
        $yqVersion = "yq detected"
    }
    if (-not $pythonVersion) {
        $pythonVersion = "$($pythonCmd.Name) detected"
    }

    Write-Ok "Runtime check: $yqVersion, $pythonVersion"
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$SkillsSource = Join-Path $RepoRoot "skills"
Test-RuntimeRequirements
$versionInfo = Resolve-CodexBmadVersion -RepoRoot $RepoRoot
Write-Ok "Installable codex-bmad-skills version: $($versionInfo.Version) (source=$($versionInfo.Source))"
Write-CodexVersionFile -RepoRoot $RepoRoot -Version $versionInfo.Version -Source $versionInfo.Source -DryRunMode $DryRun.IsPresent

if (-not (Test-Path $SkillsSource)) {
    throw "No skill source directory found (expected skills/)"
}

$SkillDirs = Get-ChildItem -Path $SkillsSource -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } |
    Sort-Object Name

if ($SkillDirs.Count -eq 0) {
    throw "No installable skills were found in $SkillsSource"
}

if (-not $DryRun) {
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null
}

Copy-ProjectReadme -RepoRoot $RepoRoot -DestPath $Dest -DryRunMode $DryRun.IsPresent -ForceMode $Force.IsPresent

$Installed = 0
$Skipped = 0

foreach ($Skill in $SkillDirs) {
    $Target = Join-Path $Dest $Skill.Name

    if ((Test-Path $Target) -and (-not $Force)) {
        Write-Warn "Skill exists, skipping: $Target"
        $Skipped++
        continue
    }

    if ($DryRun) {
        Write-Info "Would install $($Skill.Name) -> $Target"
        $Installed++
        continue
    }

    if (Test-Path $Target) {
        Remove-Item -Path $Target -Recurse -Force
    }

    Copy-Item -Path $Skill.FullName -Destination $Target -Recurse
    Write-Ok "Installed $($Skill.Name)"
    $Installed++
}

Write-Ok "Done. source=$SkillsSource dest=$Dest installed=$Installed skipped=$Skipped"
