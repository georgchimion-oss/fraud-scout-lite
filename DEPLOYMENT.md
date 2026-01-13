# Fraud Scout Lite - Deployment Guide

## Important: Power Apps Code Apps vs Canvas Apps

**Power Apps Code Apps** are deployed via CLI (`pac code push`), NOT imported as .msapp files.

This is a **custom page** approach, not a traditional canvas app.

---

## Prerequisites

1. **Power Apps CLI** (pac) installed
2. **Node.js** v18+ installed
3. **Git** installed
4. **Power Platform environment** with appropriate permissions

---

## Deployment Steps

### Step 1: Clone the Repository

```powershell
cd C:\Users\YourName\Documents
git clone https://github.com/georgchimion-oss/fraud-scout-lite.git
cd fraud-scout-lite
```

### Step 2: Install Dependencies

```powershell
npm install
```

### Step 3: Build the Application

```powershell
npm run build
```

This creates a production build in the `dist/` folder.

### Step 4: Authenticate

```powershell
pac auth create
```

Follow the browser prompts to sign in.

### Step 5: Select Environment

```powershell
# List environments
pac env list

# Select your target environment
pac env select --environment <YOUR_ENV_ID>
```

### Step 6: Initialize Code Component (First Time Only)

```powershell
pac code init --name FraudScoutLite --displayname "Fraud Scout Lite"
```

This creates the necessary metadata files.

### Step 7: Push to Power Platform

```powershell
pac code push
```

Wait for the deployment to complete (30-60 seconds).

---

## Alternative: Use the Automated Script

Instead of Steps 3-7, run:

```powershell
.\scripts\publish.ps1
```

This handles everything automatically.

---

## Accessing the App

**IMPORTANT**: Code Apps don't appear in the "Apps" list like canvas apps.

### Where to Find It:

1. Go to https://make.powerapps.com
2. Select your environment
3. Navigate to **Solutions**
4. Create a new solution (or use an existing one)
5. Add a new **Custom Page**
6. Select **Fraud Scout Lite** from the code components

### OR Use This Approach:

Create a Model-Driven App or Canvas App and embed the code component:

#### In a Canvas App:
1. Create a new Canvas App
2. Insert → Custom → Import components
3. Select "Code" tab
4. Find "Fraud Scout Lite"
5. Add to screen

#### In a Model-Driven App:
1. Create/edit a Model-Driven App
2. Add a new page
3. Select "Custom Page"
4. Choose "Fraud Scout Lite"

---

## Why No .msapp File?

Power Apps Code Apps use a **different architecture**:

- **Canvas Apps** (.msapp): PowerFx formulas + controls
- **Code Apps**: React/TypeScript compiled to JavaScript

Code Apps are deployed as **custom code components**, not standalone apps.

---

## Making Updates

After code changes:

```powershell
npm run build
pac code push
```

The component updates automatically.

---

## Troubleshooting

### "pac: command not found"

Install Power Apps CLI:
```powershell
winget install Microsoft.PowerPlatformCLI
```

Or download from:
https://learn.microsoft.com/power-platform/developer/cli/introduction

### "No environment selected"

```powershell
pac env select --environment <ENV_ID>
```

### "Insufficient permissions"

You need:
- System Administrator or System Customizer role
- Or "Create" permission on Custom Controls

Contact your Power Platform admin.

### Build Fails

```powershell
rm -r node_modules, dist
npm install
npm run build
```

---

## Development Workflow

```powershell
# Local development
npm run dev
# Opens http://localhost:5173

# Test locally
# Make changes in src/

# When ready to deploy
npm run build
pac code push
```

---

## Understanding Code Apps

Code Apps are **embedded components**, not standalone apps. They run inside:

1. Canvas Apps (as custom components)
2. Model-Driven Apps (as custom pages)
3. Portals (as embedded components)

Think of them as **widgets** rather than full applications.

---

## Next Steps

1. Deploy the code component with `pac code push`
2. Create a Canvas App or Model-Driven App
3. Embed the Fraud Scout Lite component
4. Publish the container app
5. Share with users

---

**For more details**: See README.md and QUICKSTART.md
