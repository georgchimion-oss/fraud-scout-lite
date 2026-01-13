# Fraud Scout Lite - Power Apps Code App

A demonstration Power Apps Code App for fraud risk assessment, built with React + TypeScript + Vite.

## Features

- **Offline-first**: All data stored in localStorage (no Dataverse, SharePoint, or external APIs)
- **Companies**: Browse and search 15 pre-seeded companies
- **Risk Assessments**: Create and score fraud risk assessments
- **Deterministic Scoring**: Same inputs always produce same risk scores
- **Admin Panel**: Reset demo data and manage app settings

## Prerequisites

Before publishing this app, ensure you have:

1. **Node.js** (v18 or higher) - [Download here](https://nodejs.org/)
2. **Power Apps CLI (pac)** - [Install guide](https://learn.microsoft.com/power-platform/developer/cli/introduction)
3. **VS Code** (recommended) - [Download here](https://code.visualstudio.com/)

## Quick Start (Local Development)

```powershell
# 1. Install dependencies
npm install

# 2. Run locally
npm run dev

# 3. Open browser to http://localhost:5173
```

## Publishing to Power Platform

### Step 1: Authenticate with Power Platform

```powershell
# Create authentication profile
pac auth create

# Follow the browser login prompts
```

### Step 2: Select Your Environment

```powershell
# List available environments
pac env list

# Select your target environment
pac env select --environment <YOUR_ENV_ID>
```

### Step 3: Publish the App

**Option A: Use the automated script**

```powershell
# Run from repo root
.\scripts\publish.ps1
```

**Option B: Manual steps**

```powershell
# Build the app
npm run build

# Push to Power Platform
pac code push
```

### Step 4: Find Your App

1. Go to [make.powerapps.com](https://make.powerapps.com)
2. Select your environment (top right)
3. Click **Apps** in left navigation
4. Look for **"Fraud Scout Lite"** in the list
5. Click to open or share with users

## Development Commands

```powershell
# Install dependencies
npm install

# Run dev server (hot reload)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run linter
npm run lint

# Run tests
npm test

# Format code
npm run format
```

## Project Structure

- `/src/screens/` - Main application screens (Companies, Assessments, Admin)
- `/src/data/` - Data layer (localStorage CRUD, seeding, scoring logic)
- `/src/types/` - TypeScript type definitions
- `/src/components/` - Reusable UI components
- `/tests/` - Unit tests
- `/scripts/` - Automation scripts
- `/docs/` - Documentation

## Troubleshooting

### "pac: command not found"

Install Power Apps CLI: https://learn.microsoft.com/power-platform/developer/cli/introduction

### "No environment selected"

Run `pac env select --environment <ENV_ID>` before publishing.

### "Authentication required"

Run `pac auth create` to login.

### Build errors

Delete `node_modules` and `dist`, then:
```powershell
npm install
npm run build
```

## Tech Stack

- **React 18** - UI framework
- **TypeScript** - Type safety
- **Vite** - Fast build tool
- **React Router** - Client-side routing
- **Vitest** - Unit testing
- **ESLint + Prettier** - Code quality

## Demo Talk Track

See [docs/DEMO.md](/docs/DEMO.md) for a complete 5-7 minute demonstration script.

## License

MIT
