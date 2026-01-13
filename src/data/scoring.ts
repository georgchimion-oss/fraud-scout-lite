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
  const severeFactors = assessment.riskFactors.filter((f) =>
    ['Regulatory Issues', 'Offshore Entities', 'High Cash Transactions'].includes(f)
  )
  if (severeFactors.length >= 2) {
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
