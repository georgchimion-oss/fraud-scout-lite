#!/bin/bash

# Create Header component
cat > src/components/Header.tsx << 'EOF'
import { Link } from 'react-router-dom'

export default function Header() {
  return (
    <header className="header">
      <div className="header-content">
        <h1>🔍 Fraud Scout Lite</h1>
        <nav className="nav">
          <Link to="/">Companies</Link>
          <Link to="/admin">Admin</Link>
        </nav>
      </div>
    </header>
  )
}
EOF

# Create LoadingSpinner component
cat > src/components/LoadingSpinner.tsx << 'EOF'
export default function LoadingSpinner() {
  return (
    <div className="loading">
      <p>Loading...</p>
    </div>
  )
}
EOF

# Create Companies screen
cat > src/screens/Companies.tsx << 'EOF'
import { useState, useMemo } from 'react'
import { useNavigate } from 'react-router-dom'
import { getCompanies } from '../data/dataLayer'

export default function Companies() {
  const [searchTerm, setSearchTerm] = useState('')
  const companies = getCompanies()
  const navigate = useNavigate()

  const filteredCompanies = useMemo(() => {
    if (!searchTerm) return companies
    const term = searchTerm.toLowerCase()
    return companies.filter(
      (c) =>
        c.name.toLowerCase().includes(term) ||
        c.industry.toLowerCase().includes(term) ||
        c.country.toLowerCase().includes(term) ||
        c.region.toLowerCase().includes(term)
    )
  }, [companies, searchTerm])

  return (
    <div>
      <div className="card">
        <h2>Companies ({companies.length})</h2>
        <input
          type="text"
          className="search-bar"
          placeholder="Search by name, industry, country, or region..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      <div className="companies-grid">
        {filteredCompanies.map((company) => (
          <div
            key={company.id}
            className="company-card"
            onClick={() => navigate(`/company/${company.id}`)}
          >
            <h3>{company.name}</h3>
            <div className="company-meta">
              <span>🏢 {company.industry}</span>
              <span>🌍 {company.region}</span>
              <span>📍 {company.country}</span>
              <span>📊 {company.size}</span>
              <span>📅 Founded {company.foundedYear}</span>
            </div>
          </div>
        ))}
      </div>

      {filteredCompanies.length === 0 && (
        <div className="empty-state">
          <h3>No companies found</h3>
          <p>Try adjusting your search term</p>
        </div>
      )}
    </div>
  )
}
EOF

# Create CompanyDetail screen
cat > src/screens/CompanyDetail.tsx << 'EOF'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { getCompanyById, getAssessmentsByCompany } from '../data/dataLayer'

export default function CompanyDetail() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const company = getCompanyById(id!)
  const assessments = getAssessmentsByCompany(id!)

  if (!company) {
    return (
      <div className="card">
        <h2>Company not found</h2>
        <button className="btn btn-secondary" onClick={() => navigate('/')}>
          Back to Companies
        </button>
      </div>
    )
  }

  return (
    <div>
      <div className="card">
        <h2>{company.name}</h2>
        <div className="info-grid">
          <div className="info-item">
            <label>Industry</label>
            <value>{company.industry}</value>
          </div>
          <div className="info-item">
            <label>Region</label>
            <value>{company.region}</value>
          </div>
          <div className="info-item">
            <label>Country</label>
            <value>{company.country}</value>
          </div>
          <div className="info-item">
            <label>Size</label>
            <value>{company.size}</value>
          </div>
          <div className="info-item">
            <label>Founded</label>
            <value>{company.foundedYear}</value>
          </div>
        </div>
        <div className="button-group">
          <button className="btn btn-secondary" onClick={() => navigate('/')}>
            ← Back
          </button>
          <Link
            to={`/company/${company.id}/assessment/new`}
            className="btn btn-primary"
          >
            + Start New Assessment
          </Link>
        </div>
      </div>

      <div className="card">
        <h2>Assessments ({assessments.length})</h2>
        {assessments.length === 0 ? (
          <div className="empty-state">
            <p>No assessments yet</p>
          </div>
        ) : (
          <div className="assessment-list">
            {assessments.map((assessment) => (
              <div
                key={assessment.id}
                className="assessment-item"
                onClick={() => navigate(`/assessment/${assessment.id}`)}
              >
                <h3>{assessment.name}</h3>
                <p>
                  <span className="status-badge">{assessment.status}</span>
                  {assessment.riskTier && (
                    <span className={`risk-badge risk-${assessment.riskTier.toLowerCase()}`}>
                      {assessment.riskTier} Risk
                    </span>
                  )}
                </p>
                <p style={{ color: '#718096', fontSize: '0.875rem' }}>
                  Created: {new Date(assessment.createdAt).toLocaleString()}
                </p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
EOF

# Create NewAssessment screen (part 1 of 2 - split due to length)
cat > src/screens/NewAssessment.tsx << 'EOF'
import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { getCompanyById, createAssessment } from '../data/dataLayer'
import type { RiskFactor, RevenueBand } from '../types'

const RISK_FACTORS: RiskFactor[] = [
  'Complex Ownership',
  'High Cash Transactions',
  'Offshore Entities',
  'Rapid Growth',
  'Regulatory Issues',
  'Related Party Transactions',
  'Unusual Revenue Patterns',
]

const REVENUE_BANDS: RevenueBand[] = [
  '< $1M',
  '$1M - $10M',
  '$10M - $100M',
  '$100M - $1B',
  '> $1B',
]

export default function NewAssessment() {
  const { companyId } = useParams<{ companyId: string }>()
  const navigate = useNavigate()
  const company = getCompanyById(companyId!)

  const [name, setName] = useState('')
  const [notes, setNotes] = useState('')
  const [riskFactors, setRiskFactors] = useState<RiskFactor[]>([])
  const [country, setCountry] = useState(company?.country || '')
  const [revenueBand, setRevenueBand] = useState<RevenueBand>('$10M - $100M')

  if (!company) {
    return (
      <div className="card">
        <h2>Company not found</h2>
        <button className="btn btn-secondary" onClick={() => navigate('/')}>
          Back to Companies
        </button>
      </div>
    )
  }

  const handleToggleRiskFactor = (factor: RiskFactor) => {
    setRiskFactors((prev) =>
      prev.includes(factor)
        ? prev.filter((f) => f !== factor)
        : [...prev, factor]
    )
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    const assessment = {
      id: `a-${Date.now()}`,
      companyId: company.id,
      name,
      notes,
      riskFactors,
      country,
      revenueBand,
      status: 'Open' as const,
      createdAt: new Date().toISOString(),
    }

    createAssessment(assessment)
    navigate(`/assessment/${assessment.id}`)
  }

  return (
    <div>
      <div className="card">
        <h2>New Assessment for {company.name}</h2>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Assessment Name *</label>
            <input
              type="text"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g., Q4 2023 Risk Review"
            />
          </div>

          <div className="form-group">
            <label>Notes</label>
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              rows={4}
              placeholder="Additional context or observations..."
            />
          </div>

          <div className="form-group">
            <label>Risk Factors (select all that apply)</label>
            <div className="checkbox-group">
              {RISK_FACTORS.map((factor) => (
                <div key={factor} className="checkbox-item">
                  <input
                    type="checkbox"
                    id={factor}
                    checked={riskFactors.includes(factor)}
                    onChange={() => handleToggleRiskFactor(factor)}
                  />
                  <label htmlFor={factor}>{factor}</label>
                </div>
              ))}
            </div>
          </div>

          <div className="form-group">
            <label>Country *</label>
            <input
              type="text"
              required
              value={country}
              onChange={(e) => setCountry(e.target.value)}
              placeholder="Country of operations"
            />
          </div>

          <div className="form-group">
            <label>Revenue Band *</label>
            <select
              required
              value={revenueBand}
              onChange={(e) => setRevenueBand(e.target.value as RevenueBand)}
            >
              {REVENUE_BANDS.map((band) => (
                <option key={band} value={band}>
                  {band}
                </option>
              ))}
            </select>
          </div>

          <div className="button-group">
            <button
              type="button"
              className="btn btn-secondary"
              onClick={() => navigate(`/company/${company.id}`)}
            >
              Cancel
            </button>
            <button type="submit" className="btn btn-primary">
              Create Assessment
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
EOF

echo "✅ Screen components created (part 1)!"
