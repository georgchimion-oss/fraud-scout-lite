# Fraud Scout Lite - Build and Package
Write-Host "Building Fraud Scout Lite..." -ForegroundColor Cyan

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Yellow
$nodeCheck = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCheck) {
    Write-Host "ERROR: Node.js not found!" -ForegroundColor Red
    exit 1
}
Write-Host "OK: Node.js found" -ForegroundColor Green

# Check npm
Write-Host "Checking npm..." -ForegroundColor Yellow
$npmCheck = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmCheck) {
    Write-Host "ERROR: npm not found!" -ForegroundColor Red
    exit 1
}
Write-Host "OK: npm found" -ForegroundColor Green

# Install dependencies
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: npm install failed!" -ForegroundColor Red
        exit 1
    }
}

# Build
Write-Host "Building app..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "SUCCESS! App built successfully." -ForegroundColor Green
Write-Host "Output in: dist/" -ForegroundColor Cyan
Write-Host ""
Write-Host "To deploy:" -ForegroundColor Yellow
Write-Host "  1. Go to make.powerapps.com" -ForegroundColor White
Write-Host "  2. Create new Canvas App" -ForegroundColor White  
Write-Host "  3. File > Save As > Download" -ForegroundColor White
Write-Host "  4. Or use pac canvas pack to create .msapp" -ForegroundColor White
