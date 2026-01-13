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
