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
