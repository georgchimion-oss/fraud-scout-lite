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
