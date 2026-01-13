# Fraud Scout Lite - Demo Talk Track

**Duration**: 5-7 minutes  
**Audience**: Business stakeholders, compliance officers, fraud investigators

---

## Introduction (30 seconds)

> "Today I'll show you Fraud Scout Lite, a demonstration app that helps assess fraud risk for companies using a systematic, offline-first approach. This is built as a Power Apps Code App, meaning it can run entirely in the browser with no backend dependencies."

---

## 1. Companies Overview (1 minute)

**Navigate to:** Home screen (Companies list)

> "We start with a portfolio of 15 companies across various industries and regions. Each company has basic profile information: industry, region, country, company size, and founding year."

**Action:** Use the search bar

> "I can quickly filter by typing—let's search for 'energy' to see our energy sector companies."

**Action:** Click on "Northern Lights Energy AS"

---

## 2. Company Profile (1 minute)

**On:** Company Detail screen

> "Here's the detailed view for Northern Lights Energy. We see:
> - Industry and geographic footprint
> - Company size and age
> - A history of all fraud risk assessments we've conducted"

**Action:** Click "Start New Assessment"

---

## 3. Creating an Assessment (2 minutes)

**On:** New Assessment form

> "When we start a new assessment, we capture several key risk indicators:
> 
> 1. **Assessment name** - for tracking purposes
> 2. **Notes** - free-form observations
> 3. **Risk factors** - these are common fraud red flags"

**Action:** Check several risk factors

> "Let's select a few concerning factors:
> - Offshore Entities
> - High Cash Transactions
> - Regulatory Issues"

**Action:** Fill in revenue band

> "We also capture the company's revenue band and country of operation. High-risk jurisdictions or certain revenue profiles can elevate risk scores."

**Action:** Click "Create Assessment"

---

## 4. Running the Fraud Scout (1.5 minutes)

**On:** Assessment Detail (newly created)

> "Now we're looking at the assessment detail. It shows:
> - Status: Open
> - All the risk factors we selected
> - The country and revenue band"

**Action:** Click "Run Fraud Scout (Offline)"

> "When I click 'Run Fraud Scout,' the app uses a deterministic scoring algorithm. This means:
> - No external API calls
> - Same inputs always produce the same score
> - All logic runs client-side
> 
> The system processes multiple factors including:
> - Number and severity of risk factors
> - High-risk jurisdictions
> - Revenue band risk profile
> - Combinations of severe factors"

**Wait for scoring to complete**

---

## 5. Reviewing Results (1.5 minutes)

**On:** Scored assessment

> "The assessment is now scored. Let's review:
> 
> **Risk Score**: We see a numerical score from 0-100
> **Risk Tier**: Color-coded as Low, Medium, High, or Critical
> **Scoring Factors**: A breakdown showing exactly how points were assigned
> **Red Flags**: Specific warnings for high-risk combinations"

**Action:** Scroll through reasons and red flags

> "Notice the transparency—every point is explained. For example:
> - 'Regulatory Issues (+30 points)'
> - 'Operations in high-risk jurisdiction: Cayman Islands'
> - 'Multiple severe risk factors identified'
> 
> This deterministic approach ensures consistency and auditability."

**Action:** Click back to company

> "I can now see this scored assessment in the company's history."

---

## 6. Admin Panel (30 seconds)

**Navigate to:** Admin

> "Finally, the admin panel lets me:
> - Reset demo data for clean demonstrations
> - Toggle between two different company datasets (A and B)
> - View the app version
> 
> This is useful for training scenarios or testing different risk profiles."

---

## Conclusion (30 seconds)

**Navigate back to:** Companies

> "To summarize, Fraud Scout Lite demonstrates:
> 
> 1. **Offline-first architecture** - no dependencies on external systems
> 2. **Deterministic scoring** - transparent, repeatable risk calculations
> 3. **Power Apps Code App** - modern web tech (React + TypeScript) deployed to Power Platform
> 4. **Professional UI** - clean, intuitive interface for business users
> 
> This approach could be extended with real data sources, custom risk models, and integration with enterprise systems."

---

## Q&A Prompts

Common questions and answers:

**Q: "Does this connect to our real company data?"**  
A: "This demo uses localStorage. In production, you'd integrate with Dataverse, SharePoint, or custom APIs."

**Q: "Can we customize the risk factors?"**  
A: "Absolutely. The risk factors, scoring weights, and logic are all defined in code and easily adjustable."

**Q: "What if we want to add workflow approvals?"**  
A: "Power Platform supports workflow triggers. You could send scored assessments to Power Automate for approval routing."

**Q: "How do we deploy this?"**  
A: "Using the Power Apps CLI (pac code push). It becomes a regular app in your Power Apps environment."

---

**End of Demo**
