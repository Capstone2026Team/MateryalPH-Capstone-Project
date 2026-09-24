import { useEffect, type ReactNode } from 'react'
import { useNavigate } from 'react-router-dom'
import { getSession } from '../lib/auth-api'

export function AuthenticatedPublicPage({ children }: { children: ReactNode }) {
  const navigate = useNavigate()
  useEffect(() => {
    let active = true
    void getSession().then(() => { if (active) navigate('/entry', { replace: true }) }).catch(() => { /* Public pages remain available without a confirmed session. */ })
    return () => { active = false }
  }, [navigate])
  return children
}
