# Create .msapp package for Fraud Scout Lite Code App

Write-Host "Creating .msapp package..." -ForegroundColor Cyan

# Build the React app first
Write-Host "Building React app..." -ForegroundColor Yellow
cd ..
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build complete!" -ForegroundColor Green

# Now package with pac
Write-Host "Packaging with pac canvas pack..." -ForegroundColor Yellow
cd PowerAppsApp

pac canvas pack --msapp FraudScoutLite.msapp --sources .

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Packaging failed!" -ForegroundColor Red
    Write-Host "Make sure you have the Power Apps CLI installed" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "SUCCESS!" -ForegroundColor Green
Write-Host "Created: PowerAppsApp/FraudScoutLite.msapp" -ForegroundColor Cyan
Write-Host ""
Write-Host "To import:" -ForegroundColor Yellow
Write-Host "  1. Go to make.powerapps.com" -ForegroundColor White
Write-Host "  2. Apps > Import canvas app" -ForegroundColor White
Write-Host "  3. Upload FraudScoutLite.msapp" -ForegroundColor White
