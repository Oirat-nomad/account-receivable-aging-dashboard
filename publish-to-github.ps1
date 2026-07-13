# Publish Pet Project to GitHub
# Run AFTER: gh auth login

$ErrorActionPreference = "Stop"
Set-Location -LiteralPath "$PSScriptRoot"

$gh = "C:\Program Files\GitHub CLI\gh.exe"
$git = "C:\Program Files\Git\cmd\git.exe"

Write-Host "Checking GitHub login..." -ForegroundColor Cyan
& $gh auth status
if ($LASTEXITCODE -ne 0) {
    Write-Host "Not logged in. Run: gh auth login" -ForegroundColor Yellow
    exit 1
}

$repoName = "account-receivable-aging-dashboard"
$exists = & $gh repo view $repoName 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Repo already exists. Pushing..." -ForegroundColor Yellow
    & $git branch -M main
    & $git push -u origin main
} else {
    Write-Host "Creating public repo: $repoName" -ForegroundColor Cyan
    & $gh repo create $repoName `
        --public `
        --source=. `
        --remote=origin `
        --description "Summer 2026 Tuition and AR Aging Dashboard - Excel portfolio project for higher ed finance reporting" `
        --push
}

$url = & $gh repo view --json url -q .url
Write-Host ""
Write-Host "Done! Repository URL:" -ForegroundColor Green
Write-Host $url
