# Building Fraud Scout Lite for Import

## What is a Power Apps Code App?

A **Code App** (from vibe.powerapps.com) is a React/TypeScript app that gets packaged into a **.msapp** file that you can import into Power Apps.

**THIS IS DIFFERENT FROM:**
- Canvas Apps (PowerFx based)
- Code Components/PCF (embedded widgets)

---

## Building for Import

### Step 1: Install Dependencies

```powershell
npm install
```

### Step 2: Build the App

```powershell
npm run build
```

This creates the production build in `dist/` folder.

### Step 3: Package as Code App

Power Apps Code Apps require packaging the `dist/` folder into a specific structure that Power Platform recognizes.

**You need to:**

1. Use the Power Apps CLI with `pac canvas pack` command
2. OR manually create the proper manifest structure
3. OR use the Power Apps Studio to create a Code App template and replace the code

---

## Recommended Approach: Use Power Apps Studio

1. Go to https://make.powerapps.com
2. Create → **Code App** (not Canvas App!)
3. In the Code App editor:
   - Replace the default code with code from `src/`
   - Or upload the built `dist/` files
4. Save and publish

---

## Alternative: Manual Build (Advanced)

If you want to create an importable .msapp:

```powershell
# Build the React app
npm run build

# The dist/ folder contains your built app
# This needs to be packaged into Power Apps Code App format

# TODO: Need proper pac canvas pack command for Code Apps
```

---

## Why This is Complicated

Power Apps Code Apps are a **preview feature** and the packaging process is not fully documented.

**Two options:**

### Option A: Use the Studio
1. Create Code App in make.powerapps.com
2. Edit code directly in browser
3. Save/publish from there

### Option B: Wait for Full CLI Support
Power Apps CLI (`pac`) doesn't have full Code App support yet for local development → import workflow.

---

## Current State

This repo contains:
- ✅ Full React + TypeScript source code
- ✅ Build scripts (`npm run build`)
- ✅ Production-ready `dist/` output
- ❌ Automated .msapp packaging (not supported by pac CLI for Code Apps yet)

---

## Recommended Workflow

**For now, the best approach is:**

1. Build locally: `npm run build`
2. Go to make.powerapps.com
3. Create a new Code App
4. Copy/paste the code from `src/` into the online editor
5. Publish from there

When Microsoft adds full Code App CLI support, we'll update this repo.

---

## Why Not Just Canvas App?

You asked for a **Code App** specifically - these use React/TypeScript (not PowerFx) and offer:
- Modern web development stack
- Better TypeScript support
- npm package ecosystem
- Familiar React patterns

If you want an **importable .msapp now**, we'd need to convert this to a **Canvas App** (PowerFx based) instead.

---

**Would you like me to:**
1. Convert this to a Canvas App (.msapp file) instead?
2. Or keep as Code App and provide copy/paste instructions for the online editor?

Let me know which direction you prefer!
