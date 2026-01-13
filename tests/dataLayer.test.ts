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
