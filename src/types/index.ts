export interface Company {
  id: string
  name: string
  industry: string
  region: string
  size: 'Small' | 'Medium' | 'Large' | 'Enterprise'
  country: string
  foundedYear: number
}

export type RiskFactor =
  | 'Complex Ownership'
  | 'High Cash Transactions'
  | 'Offshore Entities'
  | 'Rapid Growth'
  | 'Regulatory Issues'
  | 'Related Party Transactions'
  | 'Unusual Revenue Patterns'

export type RiskTier = 'Low' | 'Medium' | 'High' | 'Critical'

export type AssessmentStatus = 'Open' | 'Scored' | 'Reviewed'

export type RevenueBand =
  | '< $1M'
  | '$1M - $10M'
  | '$10M - $100M'
  | '$100M - $1B'
  | '> $1B'

export interface Assessment {
  id: string
  companyId: string
  name: string
  notes: string
  riskFactors: RiskFactor[]
  country: string
  revenueBand: RevenueBand
  status: AssessmentStatus
  createdAt: string
  scoredAt?: string
  riskScore?: number
  riskTier?: RiskTier
  reasons?: string[]
  redFlags?: string[]
}

export interface ScoringResult {
  riskScore: number
  riskTier: RiskTier
  reasons: string[]
  redFlags: string[]
}

export type DatasetVersion = 'A' | 'B'

export interface AppSettings {
  datasetVersion: DatasetVersion
  appVersion: string
}
