import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Header from './components/Header'
import Companies from './screens/Companies'
import CompanyDetail from './screens/CompanyDetail'
import NewAssessment from './screens/NewAssessment'
import AssessmentDetail from './screens/AssessmentDetail'
import Admin from './screens/Admin'

function App() {
  return (
    <BrowserRouter>
      <div className="app">
        <Header />
        <main className="main-content">
          <Routes>
            <Route path="/" element={<Companies />} />
            <Route path="/company/:id" element={<CompanyDetail />} />
            <Route path="/company/:companyId/assessment/new" element={<NewAssessment />} />
            <Route path="/assessment/:id" element={<AssessmentDetail />} />
            <Route path="/admin" element={<Admin />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  )
}

export default App
