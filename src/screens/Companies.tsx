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
