import { Link } from 'react-router-dom'

export default function Header() {
  return (
    <header className="header">
      <div className="header-content">
        <h1>🔍 Fraud Scout Lite</h1>
        <nav className="nav">
          <Link to="/">Companies</Link>
          <Link to="/admin">Admin</Link>
        </nav>
      </div>
    </header>
  )
}
