#!/bin/bash

# Create scoring.ts
cat > src/data/scoring.ts << 'EOF'
import type { Assessment, ScoringResult, RiskTier } from '../types'

const HIGH_RISK_COUNTRIES = [
  'Cayman Islands',
  'British Virgin Islands',
  'Panama',
  'Cyprus',
  'Malta',
  'Seychelles',
]

const RISK_FACTOR_SCORES: Record<string, number> = {
  'Complex Ownership': 15,
  'High Cash Transactions': 20,
  'Offshore Entities': 25,
  'Rapid Growth': 10,
  'Regulatory Issues': 30,
  'Related Party Transactions': 15,
  'Unusual Revenue Patterns': 20,
}

const REVENUE_BAND_SCORES: Record<string, number> = {
  '< $1M': 5,
  '$1M - $10M': 10,
  '$10M - $100M': 15,
  '$100M - $1B': 10,
  '> $1B': 5,
}

export function calculateRiskScore(assessment: Assessment): ScoringResult {
  let score = 0
  const reasons: string[] = []
  const redFlags: string[] = []

  // Risk factors scoring
  assessment.riskFactors.forEach((factor) => {
    const points = RISK_FACTOR_SCORES[factor] || 0
    score += points
    reasons.push(`${factor} (+${points} points)`)
  })

  // High-risk country
  if (HIGH_RISK_COUNTRIES.includes(assessment.country)) {
    score += 20
    redFlags.push(`Operations in high-risk jurisdiction: ${assessment.country}`)
  }

  // Revenue band scoring
  const revenuePoints = REVENUE_BAND_SCORES[assessment.revenueBand] || 0
  score += revenuePoints
  reasons.push(`Revenue band ${assessment.revenueBand} (+${revenuePoints} points)`)

  // Multiple high-severity factors
  const severeFact

ors = assessment.riskFactors.filter((f) =>
    ['Regulatory Issues', 'Offshore Entities', 'High Cash Transactions'].includes(f)
  )
  if (severeFact

ors.length >= 2) {
    score += 10
    redFlags.push('Multiple severe risk factors identified')
  }

  // Cap score at 100
  score = Math.min(score, 100)

  // Determine tier
  const riskTier: RiskTier =
    score >= 75 ? 'Critical' : score >= 50 ? 'High' : score >= 25 ? 'Medium' : 'Low'

  return {
    riskScore: score,
    riskTier,
    reasons,
    redFlags,
  }
}
EOF

# Create dataLayer.ts
cat > src/data/dataLayer.ts << 'EOF'
import type {
  Company,
  Assessment,
  AppSettings,
  DatasetVersion,
} from '../types'
import { getSeedCompanies } from './seed'

const COMPANIES_KEY = 'fraud-scout-companies'
const ASSESSMENTS_KEY = 'fraud-scout-assessments'
const SETTINGS_KEY = 'fraud-scout-settings'

// Companies
export function getCompanies(): Company[] {
  const data = localStorage.getItem(COMPANIES_KEY)
  if (!data) return []
  return JSON.parse(data)
}

export function setCompanies(companies: Company[]): void {
  localStorage.setItem(COMPANIES_KEY, JSON.stringify(companies))
}

export function getCompanyById(id: string): Company | undefined {
  return getCompanies().find((c) => c.id === id)
}

// Assessments
export function getAssessments(): Assessment[] {
  const data = localStorage.getItem(ASSESSMENTS_KEY)
  if (!data) return []
  return JSON.parse(data)
}

export function setAssessments(assessments: Assessment[]): void {
  localStorage.setItem(ASSESSMENTS_KEY, JSON.stringify(assessments))
}

export function getAssessmentById(id: string): Assessment | undefined {
  return getAssessments().find((a) => a.id === id)
}

export function getAssessmentsByCompany(companyId: string): Assessment[] {
  return getAssessments().filter((a) => a.companyId === companyId)
}

export function createAssessment(assessment: Assessment): void {
  const assessments = getAssessments()
  assessments.push(assessment)
  setAssessments(assessments)
}

export function updateAssessment(id: string, updates: Partial<Assessment>): void {
  const assessments = getAssessments()
  const index = assessments.findIndex((a) => a.id === id)
  if (index !== -1) {
    assessments[index] = { ...assessments[index], ...updates }
    setAssessments(assessments)
  }
}

// Settings
export function getSettings(): AppSettings {
  const data = localStorage.getItem(SETTINGS_KEY)
  if (!data) {
    return { datasetVersion: 'A', appVersion: '1.0.0' }
  }
  return JSON.parse(data)
}

export function setSettings(settings: AppSettings): void {
  localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings))
}

// Demo data reset
export function resetDemoData(datasetVersion?: DatasetVersion): void {
  const version = datasetVersion || getSettings().datasetVersion
  const companies = getSeedCompanies(version)
  setCompanies(companies)
  setAssessments([])
  setSettings({ ...getSettings(), datasetVersion: version })
}

// Initialize on first load
export function initializeData(): void {
  const companies = getCompanies()
  if (companies.length === 0) {
    resetDemoData('A')
  }
}
EOF

# Create main.tsx
cat > src/main.tsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './App.css'
import { initializeData } from './data/dataLayer.ts'

// Initialize demo data on first load
initializeData()

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
EOF

# Create App.tsx
cat > src/App.tsx << 'EOF'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Header from './components/Header'
import Companies from './screens/Companies'
import CompanyDetail from './screens/CompanyDetail'
import NewAssessment from './screens/NewAssessment'
import AssessmentDetail from './screens/AssessmentDetail'
import Admin from './screens/Admin'

function App() {
  return (
    <BrowserRouter>
      <div className="app">
        <Header />
        <main className="main-content">
          <Routes>
            <Route path="/" element={<Companies />} />
            <Route path="/company/:id" element={<CompanyDetail />} />
            <Route path="/company/:companyId/assessment/new" element={<NewAssessment />} />
            <Route path="/assessment/:id" element={<AssessmentDetail />} />
            <Route path="/admin" element={<Admin />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

# Create App.css
cat > src/App.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
  background: #f5f7fa;
  color: #2d3748;
}

.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1.5rem 2rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header h1 {
  font-size: 1.75rem;
  font-weight: 700;
}

.nav {
  display: flex;
  gap: 1rem;
}

.nav a {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  transition: background 0.2s;
}

.nav a:hover {
  background: rgba(255,255,255,0.2);
}

.card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  margin-bottom: 1.5rem;
}

.card h2 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #1a202c;
}

.search-bar {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  font-size: 1rem;
  margin-bottom: 1.5rem;
  transition: border-color 0.2s;
}

.search-bar:focus {
  outline: none;
  border-color: #667eea;
}

.companies-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1rem;
}

.company-card {
  background: white;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  padding: 1.5rem;
  cursor: pointer;
  transition: all 0.2s;
}

.company-card:hover {
  border-color: #667eea;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
}

.company-card h3 {
  font-size: 1.25rem;
  margin-bottom: 0.5rem;
  color: #1a202c;
}

.company-meta {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  color: #718096;
  font-size: 0.875rem;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  text-decoration: none;
  display: inline-block;
  text-align: center;
}

.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-primary:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.btn-secondary {
  background: #e2e8f0;
  color: #2d3748;
}

.btn-secondary:hover {
  background: #cbd5e0;
}

.btn-danger {
  background: #f56565;
  color: white;
}

.btn-danger:hover {
  background: #e53e3e;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #2d3748;
}

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  font-size: 1rem;
  font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  outline: none;
  border-color: #667eea;
}

.checkbox-group {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 0.75rem;
}

.checkbox-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.checkbox-item input[type="checkbox"] {
  width: auto;
}

.risk-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.875rem;
}

.risk-low {
  background: #c6f6d5;
  color: #22543d;
}

.risk-medium {
  background: #fefcbf;
  color: #744210;
}

.risk-high {
  background: #fed7d7;
  color: #742a2a;
}

.risk-critical {
  background: #fc8181;
  color: white;
}

.status-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.875rem;
  background: #e2e8f0;
  color: #2d3748;
}

.assessment-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.assessment-item {
  padding: 1rem;
  background: #f7fafc;
  border-radius: 8px;
  border: 2px solid #e2e8f0;
  cursor: pointer;
  transition: all 0.2s;
}

.assessment-item:hover {
  border-color: #667eea;
  background: white;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.info-item {
  padding: 1rem;
  background: #f7fafc;
  border-radius: 8px;
}

.info-item label {
  display: block;
  font-size: 0.875rem;
  color: #718096;
  margin-bottom: 0.25rem;
}

.info-item value {
  display: block;
  font-size: 1.125rem;
  font-weight: 600;
  color: #1a202c;
}

.reasons-list,
.flags-list {
  list-style: none;
  padding: 0;
}

.reasons-list li,
.flags-list li {
  padding: 0.75rem;
  margin-bottom: 0.5rem;
  background: #f7fafc;
  border-radius: 6px;
  border-left: 4px solid #667eea;
}

.flags-list li {
  border-left-color: #f56565;
  background: #fff5f5;
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #718096;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #718096;
}

.empty-state h3 {
  margin-bottom: 1rem;
  color: #2d3748;
}

.button-group {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
}

@media (max-width: 768px) {
  .main-content {
    padding: 1rem;
  }
  
  .companies-grid {
    grid-template-columns: 1fr;
  }
  
  .info-grid {
    grid-template-columns: 1fr;
  }
  
  .button-group {
    flex-direction: column;
  }
}
EOF

echo "✅ All core files created!"
