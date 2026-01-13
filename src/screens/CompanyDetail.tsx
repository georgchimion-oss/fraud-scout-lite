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
