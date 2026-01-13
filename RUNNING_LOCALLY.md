# Running Fraud Scout Lite Locally

## Quick Start

```bash
# Install dependencies (first time only)
npm install

# Start development server
npm run dev
```

The app will open at: **http://localhost:5173**

(Note: Vite uses port 5173, not 3000)

---

## Available Commands

```bash
# Development server (with hot reload)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run tests
npm test

# Lint code
npm run lint

# Format code
npm run format
```

---

## What You'll See

When you run `npm run dev`, you'll see:

1. **Companies screen** - 15 demo companies you can search/filter
2. Click a company → **Company Detail** screen
3. Click "Start New Assessment" → **Assessment form**
4. Fill out the form → Creates assessment
5. Click "Run Fraud Scout" → **Scores the assessment** (deterministic algorithm)
6. View the results with risk score, tier, reasons, and red flags

---

## Making Changes

1. Edit files in `src/`
2. Save
3. Browser auto-refreshes (hot reload)
4. See changes instantly

---

## Stopping the Server

Press `Ctrl+C` in the terminal

---

## Port Already in Use?

If port 5173 is taken:

```bash
# Vite will automatically try the next available port
# Or specify a different port:
npm run dev -- --port 3000
```

---

## Demo Data

The app uses **localStorage** for data persistence:

- 15 companies (2 datasets: A and B)
- Assessments you create are saved locally
- Go to **Admin** screen to reset data or switch datasets

---

## Troubleshooting

### "npm: command not found"
Install Node.js from https://nodejs.org/

### "Module not found" errors
```bash
rm -rf node_modules package-lock.json
npm install
```

### Port 5173 shows blank page
Check the browser console (F12) for errors

---

**That's it! Just `npm run dev` and go to http://localhost:5173**
