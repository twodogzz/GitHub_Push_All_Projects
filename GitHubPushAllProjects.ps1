# ============================================
# Push All Projects Script
# Safely commits and pushes changes for all repos
# Author: Wayne Freestun
# ============================================

# --- USER SETTINGS ---
$BasePath = "E:\SoftwareProjects"

# Makes the script automatically write the log next to itself, no matter where you move it.

# $LogFile  = "E:\SoftwareProjects\GitHubRepoManager\PushAllProjects.log"
$LogFile = Join-Path $PSScriptRoot "PushAllProjects.log"

# --- LOGGING FUNCTION ---
function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $LogFile -Value "$timestamp  $Message"
}

Write-Log "=== Starting Push All Projects run ==="

# --- GET ALL GIT REPOS ---
$Repos = Get-ChildItem -Path $BasePath -Directory |
         Where-Object { Test-Path "$($_.FullName)\.git" }

foreach ($Repo in $Repos) {

    $RepoPath = $Repo.FullName
    Write-Host "`nChecking $($Repo.Name)..." -ForegroundColor Cyan
    Write-Log "Checking $($Repo.Name)"

    Set-Location $RepoPath

    # --- CHECK FOR CHANGES ---
    $Status = git status --porcelain

    if (-not $Status) {
        Write-Host "No changes. Skipping." -ForegroundColor DarkGray
        Write-Log "No changes in $($Repo.Name)"
        continue
    }

    Write-Host "Changes detected in $($Repo.Name):" -ForegroundColor Yellow
    Write-Host $Status

    # --- HANDLE UNTRACKED FILES ---
    $Untracked = $Status | Where-Object { $_ -match "^\?\?" }

    if ($Untracked) {
        Write-Host "`nUntracked files detected:" -ForegroundColor Magenta
        $Untracked | ForEach-Object { Write-Host "  $_" }

        $addUntracked = Read-Host "Add untracked files? (Y/N)"
        if ($addUntracked -match '^[Yy]') {
            git add . | Out-Null
            Write-Log "Added untracked files in $($Repo.Name)"
        } else {
            Write-Host "Skipping untracked files." -ForegroundColor DarkGray
            Write-Log "Skipped untracked files in $($Repo.Name)"
        }
    } else {
        git add . | Out-Null
    }

    # --- CONFIRM COMMIT ---
    $commitConfirm = Read-Host "Commit changes for $($Repo.Name)? (Y/N)"
    if ($commitConfirm -notmatch '^[Yy]') {
        Write-Host "Skipping commit." -ForegroundColor DarkGray
        Write-Log "Skipped commit for $($Repo.Name)"
        continue
    }

    # --- COMMIT MESSAGE ---
    $CommitMsg = Read-Host "Enter commit message"
    if (-not $CommitMsg) {
        $CommitMsg = "Update"
    }

    git commit -m "$CommitMsg" | Out-Null
    Write-Host "Committed." -ForegroundColor Green
    Write-Log "Committed changes in $($Repo.Name): $CommitMsg"

    # --- PUSH ---
    Write-Host "Pushing..." -ForegroundColor DarkCyan
    try {
        git push | Out-Null
        Write-Host "Pushed successfully." -ForegroundColor Green
        Write-Log "Pushed $($Repo.Name)"
    }
    catch {
        Write-Host "Push failed." -ForegroundColor Red
        Write-Log "Push FAILED for $($Repo.Name)"
    }
}

Write-Log "=== Push All Projects run complete ==="
Write-Host "`nAll done." -ForegroundColor Yellow