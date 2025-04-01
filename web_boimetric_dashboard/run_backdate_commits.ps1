# PowerShell script to run the bash script with proper environment

# Set the path to Git Bash
$gitBashPath = "C:\Program Files\Git\bin\bash.exe"

# Set the path to the script
$scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "random_backdate_commits.sh"

# Check if Git Bash exists
if (-not (Test-Path $gitBashPath)) {
    Write-Error "Git Bash not found at $gitBashPath. Please ensure Git is installed."
    exit 1
}

# Check if the script exists
if (-not (Test-Path $scriptPath)) {
    Write-Error "Script not found at $scriptPath"
    exit 1
}

# Run the script with Git Bash
Write-Host "Starting backdate commits script..." -ForegroundColor Cyan
& "$gitBashPath" -c "cd '$($PSScriptRoot -replace '\\', '/')' && ./random_backdate_commits.sh"

# Check if the script ran successfully
if ($LASTEXITCODE -ne 0) {
    Write-Error "Script failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Script completed successfully!" -ForegroundColor Green
