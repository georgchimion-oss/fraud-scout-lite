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
