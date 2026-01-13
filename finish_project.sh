#!/bin/bash

# Create AssessmentDetail screen
cat > src/screens/AssessmentDetail.tsx << 'EOF'
import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { getAssessmentById, getCompanyById, updateAssessment } from '../data/dataLayer'
import { calculateRiskScore } from '../data/scoring'

export default function AssessmentDetail() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const assessment = getAssessmentById(id!)
  const company = assessment ? getCompanyById(assessment.companyId) : null
  const [isScoring, setIsScoring] = useState(false)

  if (!assessment || !company) {
    return (
      <div className="card">
        <h2>Assessment not found</h2>
        <button className="btn btn-secondary" onClick={() => navigate('/')}>
          Back to Companies
        </button>
      </div>
    )
  }

  const handleRunScore = () => {
    setIsScoring(true)
    // Simulate processing delay
    setTimeout(() => {
      const result = calculateRiskScore(assessment)
      updateAssessment(assessment.id, {
        status: 'Scored',
        scoredAt: new Date().toISOString(),
        riskScore: result.riskScore,
        riskTier: result.riskTier,
        reasons: result.reasons,
        redFlags: result.redFlags,
      })
      setIsScoring(false)
      window.location.reload()
    }, 1500)
  }

  return (
    <div>
      <div className="card">
        <h2>{assessment.name}</h2>
        <p style={{ color: '#718096', marginBottom: '1rem' }}>
          {company.name}
        </p>
        <div className="info-grid">
          <div className="info-item">
            <label>Status</label>
            <value>
              <span className="status-badge">{assessment.status}</span>
            </value>
          </div>
          <div className="info-item">
            <label>Created</label>
            <value>{new Date(assessment.createdAt).toLocaleDateString()}</value>
          </div>
          {assessment.scoredAt && (
            <div className="info-item">
              <label>Scored</label>
              <value>{new Date(assessment.scoredAt).toLocaleDateString()}</value>
            </div>
          )}
          <div className="info-item">
            <label>Country</label>
            <value>{assessment.country}</value>
          </div>
          <div className="info-item">
            <label>Revenue Band</label>
            <value>{assessment.revenueBand}</value>
          </div>
        </div>

        {assessment.notes && (
          <div style={{ marginTop: '1rem' }}>
            <h3 style={{ marginBottom: '0.5rem' }}>Notes</h3>
            <p style={{ color: '#4a5568' }}>{assessment.notes}</p>
          </div>
        )}

        <div style={{ marginTop: '1rem' }}>
          <h3 style={{ marginBottom: '0.5rem' }}>Risk Factors</h3>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.5rem' }}>
            {assessment.riskFactors.map((factor) => (
              <span
                key={factor}
                style={{
                  padding: '0.5rem 1rem',
                  background: '#edf2f7',
                  borderRadius: '6px',
                  fontSize: '0.875rem',
                }}
              >
                {factor}
              </span>
            ))}
          </div>
        </div>

        {assessment.status === 'Open' && (
          <div className="button-group">
            <button
              className="btn btn-secondary"
              onClick={() => navigate(`/company/${company.id}`)}
            >
              ← Back
            </button>
            <button
              className="btn btn-primary"
              onClick={handleRunScore}
              disabled={isScoring}
            >
              {isScoring ? '🔄 Scoring...' : '🔍 Run Fraud Scout (Offline)'}
            </button>
          </div>
        )}
      </div>

      {assessment.status === 'Scored' && (
        <>
          <div className="card">
            <h2>Risk Score</h2>
            <div style={{ textAlign: 'center', padding: '2rem' }}>
              <div
                style={{
                  fontSize: '4rem',
                  fontWeight: 'bold',
                  color: '#667eea',
                  marginBottom: '1rem',
                }}
              >
                {assessment.riskScore}
              </div>
              <span
                className={`risk-badge risk-${assessment.riskTier?.toLowerCase()}`}
                style={{ fontSize: '1.25rem', padding: '0.75rem 1.5rem' }}
              >
                {assessment.riskTier} Risk
              </span>
            </div>
          </div>

          {assessment.reasons && assessment.reasons.length > 0 && (
            <div className="card">
              <h2>Scoring Factors</h2>
              <ul className="reasons-list">
                {assessment.reasons.map((reason, i) => (
                  <li key={i}>{reason}</li>
                ))}
              </ul>
            </div>
          )}

          {assessment.redFlags && assessment.redFlags.length > 0 && (
            <div className="card">
              <h2>⚠️ Red Flags</h2>
              <ul className="flags-list">
                {assessment.redFlags.map((flag, i) => (
                  <li key={i}>{flag}</li>
                ))}
              </ul>
            </div>
          )}

          <div className="card">
            <button
              className="btn btn-secondary"
              onClick={() => navigate(`/company/${company.id}`)}
            >
              ← Back to Company
            </button>
          </div>
        </>
      )}
    </div>
  )
}
EOF

# Create Admin screen
cat > src/screens/Admin.tsx << 'EOF'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { getSettings, setSettings, resetDemoData } from '../data/dataLayer'
import type { DatasetVersion } from '../types'

export default function Admin() {
  const navigate = useNavigate()
  const settings = getSettings()
  const [selectedDataset, setSelectedDataset] = useState<DatasetVersion>(
    settings.datasetVersion
  )

  const handleResetData = () => {
    if (
      confirm(
        'This will reset all companies and assessments to demo data. Continue?'
      )
    ) {
      resetDemoData(selectedDataset)
      alert('Demo data reset successfully!')
      window.location.reload()
    }
  }

  const handleChangeDataset = () => {
    setSettings({ ...settings, datasetVersion: selectedDataset })
    resetDemoData(selectedDataset)
    alert(`Switched to Dataset ${selectedDataset}!`)
    window.location.reload()
  }

  return (
    <div>
      <div className="card">
        <h2>Admin Panel</h2>
        <p style={{ color: '#718096', marginBottom: '1.5rem' }}>
          Manage demo data and app settings
        </p>

        <div className="info-grid">
          <div className="info-item">
            <label>App Version</label>
            <value>{settings.appVersion}</value>
          </div>
          <div className="info-item">
            <label>Current Dataset</label>
            <value>Dataset {settings.datasetVersion}</value>
          </div>
        </div>
      </div>

      <div className="card">
        <h2>Demo Dataset</h2>
        <p style={{ color: '#718096', marginBottom: '1rem' }}>
          Switch between two sets of demo companies
        </p>

        <div className="form-group">
          <label>Select Dataset</label>
          <select
            value={selectedDataset}
            onChange={(e) =>
              setSelectedDataset(e.target.value as DatasetVersion)
            }
          >
            <option value="A">Dataset A (Default)</option>
            <option value="B">Dataset B (Alternative)</option>
          </select>
        </div>

        {selectedDataset !== settings.datasetVersion && (
          <button className="btn btn-primary" onClick={handleChangeDataset}>
            Switch to Dataset {selectedDataset}
          </button>
        )}
      </div>

      <div className="card">
        <h2>Reset Demo Data</h2>
        <p style={{ color: '#718096', marginBottom: '1rem' }}>
          Reset all companies and delete all assessments
        </p>
        <button className="btn btn-danger" onClick={handleResetData}>
          🔄 Reset to Demo Data
        </button>
      </div>

      <div className="card">
        <button className="btn btn-secondary" onClick={() => navigate('/')}>
          ← Back to Companies
        </button>
      </div>
    </div>
  )
}
EOF

# Create test files
cat > tests/scoring.test.ts << 'EOF'
import { describe, it, expect } from 'vitest'
import { calculateRiskScore } from '../src/data/scoring'
import type { Assessment } from '../src/types'

describe('calculateRiskScore', () => {
  it('should calculate low risk for minimal factors', () => {
    const assessment: Assessment = {
      id: 'test-1',
      companyId: 'c1',
      name: 'Test',
      notes: '',
      riskFactors: ['Rapid Growth'],
      country: 'United States',
      revenueBand: '$1M - $10M',
      status: 'Open',
      createdAt: '2024-01-01',
    }

    const result = calculateRiskScore(assessment)
    expect(result.riskScore).toBe(20) // 10 + 10
    expect(result.riskTier).toBe('Low')
  })

  it('should calculate high risk for multiple severe factors', () => {
    const assessment: Assessment = {
      id: 'test-2',
      companyId: 'c1',
      name: 'Test',
      notes: '',
      riskFactors: ['Regulatory Issues', 'Offshore Entities', 'High Cash Transactions'],
      country: 'Cayman Islands',
      revenueBand: '$100M - $1B',
      status: 'Open',
      createdAt: '2024-01-01',
    }

    const result = calculateRiskScore(assessment)
    // 30 + 25 + 20 + 20 (country) + 10 (revenue) + 10 (multiple severe) = 115, capped at 100
    expect(result.riskScore).toBe(100)
    expect(result.riskTier).toBe('Critical')
    expect(result.redFlags.length).toBeGreaterThan(0)
  })

  it('should be deterministic (same input => same output)', () => {
    const assessment: Assessment = {
      id: 'test-3',
      companyId: 'c1',
      name: 'Test',
      notes: '',
      riskFactors: ['Complex Ownership', 'Related Party Transactions'],
      country: 'Singapore',
      revenueBand: '$10M - $100M',
      status: 'Open',
      createdAt: '2024-01-01',
    }

    const result1 = calculateRiskScore(assessment)
    const result2 = calculateRiskScore(assessment)

    expect(result1.riskScore).toBe(result2.riskScore)
    expect(result1.riskTier).toBe(result2.riskTier)
  })
})
EOF

cat > tests/dataLayer.test.ts << 'EOF'
import { describe, it, expect, beforeEach } from 'vitest'
import {
  getCompanies,
  setCompanies,
  getAssessments,
  createAssessment,
  resetDemoData,
} from '../src/data/dataLayer'
import type { Assessment } from '../src/types'

describe('dataLayer', () => {
  beforeEach(() => {
    localStorage.clear()
  })

  it('should store and retrieve companies', () => {
    const companies = [
      {
        id: 'c1',
        name: 'Test Corp',
        industry: 'Tech',
        region: 'NA',
        size: 'Small' as const,
        country: 'US',
        foundedYear: 2020,
      },
    ]

    setCompanies(companies)
    const retrieved = getCompanies()

    expect(retrieved).toHaveLength(1)
    expect(retrieved[0].name).toBe('Test Corp')
  })

  it('should create and retrieve assessments', () => {
    const assessment: Assessment = {
      id: 'a1',
      companyId: 'c1',
      name: 'Test Assessment',
      notes: '',
      riskFactors: [],
      country: 'US',
      revenueBand: '$1M - $10M',
      status: 'Open',
      createdAt: new Date().toISOString(),
    }

    createAssessment(assessment)
    const assessments = getAssessments()

    expect(assessments).toHaveLength(1)
    expect(assessments[0].id).toBe('a1')
  })

  it('should reset demo data', () => {
    resetDemoData('A')
    const companies = getCompanies()
    const assessments = getAssessments()

    expect(companies.length).toBe(15)
    expect(assessments.length).toBe(0)
  })
})
EOF

# Create PowerShell publish script
cat > scripts/publish.ps1 << 'EOF'
# Fraud Scout Lite - Publish to Power Platform
# This script checks prerequisites, builds the app, and pushes to Power Platform

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host " Fraud Scout Lite - Publishing" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Node.js is not installed!" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Node.js $nodeVersion" -ForegroundColor Green

# Check npm
Write-Host "Checking npm..." -ForegroundColor Yellow
$npmVersion = npm --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: npm is not installed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ npm $npmVersion" -ForegroundColor Green

# Check Power Apps CLI
Write-Host "Checking Power Apps CLI..." -ForegroundColor Yellow
$pacVersion = pac --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Power Apps CLI (pac) is not installed!" -ForegroundColor Red
    Write-Host "Please install from: https://learn.microsoft.com/power-platform/developer/cli/introduction" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Power Apps CLI installed" -ForegroundColor Green

# Check authentication
Write-Host "Checking authentication..." -ForegroundColor Yellow
pac auth list >$null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: No authentication profile found!" -ForegroundColor Yellow
    Write-Host "Please run: pac auth create" -ForegroundColor Yellow
    $response = Read-Host "Continue anyway? (y/n)"
    if ($response -ne "y") {
        exit 1
    }
}
Write-Host "✓ Authentication configured" -ForegroundColor Green

# Install dependencies if node_modules doesn't exist
if (-not (Test-Path "node_modules")) {
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
EOF

# Create DEMO.md
cat > docs/DEMO.md << 'EOF'
# Fraud Scout Lite - Demo Talk Track

**Duration**: 5-7 minutes  
**Audience**: Business stakeholders, compliance officers, fraud investigators

---

## Introduction (30 seconds)

> "Today I'll show you Fraud Scout Lite, a demonstration app that helps assess fraud risk for companies using a systematic, offline-first approach. This is built as a Power Apps Code App, meaning it can run entirely in the browser with no backend dependencies."

---

## 1. Companies Overview (1 minute)

**Navigate to:** Home screen (Companies list)

> "We start with a portfolio of 15 companies across various industries and regions. Each company has basic profile information: industry, region, country, company size, and founding year."

**Action:** Use the search bar

> "I can quickly filter by typing—let's search for 'energy' to see our energy sector companies."

**Action:** Click on "Northern Lights Energy AS"

---

## 2. Company Profile (1 minute)

**On:** Company Detail screen

> "Here's the detailed view for Northern Lights Energy. We see:
> - Industry and geographic footprint
> - Company size and age
> - A history of all fraud risk assessments we've conducted"

**Action:** Click "Start New Assessment"

---

## 3. Creating an Assessment (2 minutes)

**On:** New Assessment form

> "When we start a new assessment, we capture several key risk indicators:
> 
> 1. **Assessment name** - for tracking purposes
> 2. **Notes** - free-form observations
> 3. **Risk factors** - these are common fraud red flags"

**Action:** Check several risk factors

> "Let's select a few concerning factors:
> - Offshore Entities
> - High Cash Transactions
> - Regulatory Issues"

**Action:** Fill in revenue band

> "We also capture the company's revenue band and country of operation. High-risk jurisdictions or certain revenue profiles can elevate risk scores."

**Action:** Click "Create Assessment"

---

## 4. Running the Fraud Scout (1.5 minutes)

**On:** Assessment Detail (newly created)

> "Now we're looking at the assessment detail. It shows:
> - Status: Open
> - All the risk factors we selected
> - The country and revenue band"

**Action:** Click "Run Fraud Scout (Offline)"

> "When I click 'Run Fraud Scout,' the app uses a deterministic scoring algorithm. This means:
> - No external API calls
> - Same inputs always produce the same score
> - All logic runs client-side
> 
> The system processes multiple factors including:
> - Number and severity of risk factors
> - High-risk jurisdictions
> - Revenue band risk profile
> - Combinations of severe factors"

**Wait for scoring to complete**

---

## 5. Reviewing Results (1.5 minutes)

**On:** Scored assessment

> "The assessment is now scored. Let's review:
> 
> **Risk Score**: We see a numerical score from 0-100
> **Risk Tier**: Color-coded as Low, Medium, High, or Critical
> **Scoring Factors**: A breakdown showing exactly how points were assigned
> **Red Flags**: Specific warnings for high-risk combinations"

**Action:** Scroll through reasons and red flags

> "Notice the transparency—every point is explained. For example:
> - 'Regulatory Issues (+30 points)'
> - 'Operations in high-risk jurisdiction: Cayman Islands'
> - 'Multiple severe risk factors identified'
> 
> This deterministic approach ensures consistency and auditability."

**Action:** Click back to company

> "I can now see this scored assessment in the company's history."

---

## 6. Admin Panel (30 seconds)

**Navigate to:** Admin

> "Finally, the admin panel lets me:
> - Reset demo data for clean demonstrations
> - Toggle between two different company datasets (A and B)
> - View the app version
> 
> This is useful for training scenarios or testing different risk profiles."

---

## Conclusion (30 seconds)

**Navigate back to:** Companies

> "To summarize, Fraud Scout Lite demonstrates:
> 
> 1. **Offline-first architecture** - no dependencies on external systems
> 2. **Deterministic scoring** - transparent, repeatable risk calculations
> 3. **Power Apps Code App** - modern web tech (React + TypeScript) deployed to Power Platform
> 4. **Professional UI** - clean, intuitive interface for business users
> 
> This approach could be extended with real data sources, custom risk models, and integration with enterprise systems."

---

## Q&A Prompts

Common questions and answers:

**Q: "Does this connect to our real company data?"**  
A: "This demo uses localStorage. In production, you'd integrate with Dataverse, SharePoint, or custom APIs."

**Q: "Can we customize the risk factors?"**  
A: "Absolutely. The risk factors, scoring weights, and logic are all defined in code and easily adjustable."

**Q: "What if we want to add workflow approvals?"**  
A: "Power Platform supports workflow triggers. You could send scored assessments to Power Automate for approval routing."

**Q: "How do we deploy this?"**  
A: "Using the Power Apps CLI (pac code push). It becomes a regular app in your Power Apps environment."

---

**End of Demo**
EOF

echo "✅ All files created successfully!"
