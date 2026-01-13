# Fraud Scout Lite - Quick Start Guide

## For PWC Corporate Laptop

This guide assumes you have:
- ✅ VS Code installed
- ✅ Node.js installed (v18+)
- ✅ Power Apps CLI (pac) installed
- ✅ Git installed

---

## Step 1: Clone the Repository

```powershell
# Open PowerShell or Command Prompt
cd C:\Users\YourName\Documents
git clone https://github.com/georgchimion-oss/fraud-scout-lite.git
cd fraud-scout-lite
```

---

## Step 2: Install Dependencies

```powershell
npm install
```

This downloads all React, TypeScript, and Vite dependencies.

---

## Step 3: Test Locally (Optional)

```powershell
npm run dev
```

Open browser to `http://localhost:5173` to see the app running locally.

Press `Ctrl+C` to stop the dev server.

---

## Step 4: Build the App

```powershell
npm run build
```

This creates a production-ready build in the `dist/` folder.

---

## Step 5: Authenticate with Power Platform

```powershell
pac auth create
```

- A browser window will open
- Sign in with your Power Platform credentials
- Close the browser when authentication succeeds

---

## Step 6: Select Your Environment

```powershell
# List available environments
pac env list

# Select your target environment (replace <ENV_ID> with actual ID from the list)
pac env select --environment <ENV_ID>
```

Example:
```powershell
pac env select --environment a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

---

## Step 7: Push to Power Platform

```powershell
pac code push
```

Wait for the upload to complete (usually 30-60 seconds).

---

## Step 8: Open Your App

1. Go to [make.powerapps.com](https://make.powerapps.com)
2. Click the environment selector (top right)
3. Select the environment you pushed to
4. Click **Apps** in the left navigation
5. Find **"Fraud Scout Lite"** in the list
6. Click the app name to open it

---

## Automated Option

Instead of steps 4-7, you can run the automated script:

```powershell
.\scripts\publish.ps1
```

This script:
- Checks all prerequisites
- Installs dependencies (if needed)
- Builds the app
- Pushes to Power Platform
- Shows friendly error messages if anything fails

---

## Troubleshooting

### "pac: command not found"

Install Power Apps CLI:
https://learn.microsoft.com/power-platform/developer/cli/introduction

### "No environment selected"

Run:
```powershell
pac env select --environment <YOUR_ENV_ID>
```

### "Authentication required"

Run:
```powershell
pac auth create
```

### Build errors

Delete `node_modules` and `dist`, then:
```powershell
rm -r node_modules, dist
npm install
npm run build
```

---

## Making Changes

After you make code changes:

```powershell
# Test locally
npm run dev

# When ready, rebuild and push
npm run build
pac code push
```

The app will update in Power Platform.

---

## Project Structure

```
fraud-scout-lite/
├── src/
│   ├── screens/        # Main app screens
│   ├── data/           # localStorage CRUD + scoring logic
│   ├── components/     # Reusable UI components
│   └── types/          # TypeScript definitions
├── tests/              # Unit tests
├── scripts/            # Automation scripts
└── docs/               # Documentation
```

---

## Demo Talk Track

See [docs/DEMO.md](docs/DEMO.md) for a complete 5-7 minute demonstration script.

---

## Support

- GitHub Issues: https://github.com/georgchimion-oss/fraud-scout-lite/issues
- Power Apps CLI Docs: https://learn.microsoft.com/power-platform/developer/cli/introduction

---

**You're ready to go!** 🚀
