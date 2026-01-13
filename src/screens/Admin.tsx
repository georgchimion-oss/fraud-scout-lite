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
