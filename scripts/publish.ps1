# Fraud Scout Lite - Publish to Power Platform
# This script checks prerequisites, builds the app, and pushes to Power Platform

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host " Fraud Scout Lite - Publishing" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Node.js not found"
    }
    Write-Host "✓ Node.js $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Node.js is not installed!" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# Check npm
Write-Host "Checking npm..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "npm not found"
    }
    Write-Host "✓ npm $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: npm is not installed!" -ForegroundColor Red
    exit 1
}

# Check Power Apps CLI
Write-Host "Checking Power Apps CLI..." -ForegroundColor Yellow
try {
    pac --version 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "pac not found"
    }
    Write-Host "✓ Power Apps CLI installed" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Power Apps CLI (pac) is not installed!" -ForegroundColor Red
    Write-Host "Please install from: https://learn.microsoft.com/power-platform/developer/cli/introduction" -ForegroundColor Red
    exit 1
}

# Check authentication
Write-Host "Checking authentication..." -ForegroundColor Yellow
try {
    pac auth list 2>$null | Out-Null
    Write-Host "✓ Authentication configured" -ForegroundColor Green
} catch {
    Write-Host "WARNING: No authentication profile found!" -ForegroundColor Yellow
    Write-Host "Please run: pac auth create" -ForegroundColor Yellow
    $response = Read-Host "Continue anyway? (y/n)"
    if ($response -ne "y") {
        exit 1
    }
}

# Install dependencies if node_modules doesn't exist
if (-Not (Test-Path "node_modules")) {
    Write-Host ""
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: npm install failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Dependencies installed" -ForegroundColor Green
}

# Build the app
Write-Host ""
Write-Host "Building app..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Build successful" -ForegroundColor Green

# Push to Power Platform
Write-Host ""
Write-Host "Pushing to Power Platform..." -ForegroundColor Yellow
pac code push
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Push failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  1. No environment selected - run: pac env select --environment <ENV_ID>" -ForegroundColor Yellow
    Write-Host "  2. Not authenticated - run: pac auth create" -ForegroundColor Yellow
    Write-Host "  3. Insufficient permissions - contact your Power Platform admin" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host " SUCCESS!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your app has been published to Power Platform!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Go to https://make.powerapps.com" -ForegroundColor White
Write-Host "  2. Select your environment (top right)" -ForegroundColor White
Write-Host "  3. Click 'Apps' in left navigation" -ForegroundColor White
Write-Host "  4. Find 'Fraud Scout Lite' and click to open" -ForegroundColor White
Write-Host ""
