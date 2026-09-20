import { useEffect, useState } from 'react'
import { useParams, Navigate } from 'react-router-dom'
import { AccountsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration, StatusMessage } from '@materyalph/web-ui'
import { AdminShell } from './PhaseThreeAdminPages'
import { readableVerificationError } from '../lib/vendor-verification-api'

const adminPlaceholders: Record<string, string> = {
  'marketplace-analytics': 'Marketplace Analytics', 'buyer-management': 'Buyer Management', taxonomy: 'Taxonomy Management', 'product-compliance': 'Product Compliance Queue', disputes: 'Dispute and Appeal Queue', enforcement: 'Flag, Restriction, and Suspension Management', scores: 'Score and Badge Monitoring', transactions: 'Transaction Log', invoices: 'Invoice Request Log', 'budget-overrides': 'Budget Override Audit Log', settings: 'Platform Settings', moderation: 'Product Review Moderation Queue', privacy: 'Privacy Request Management', integrations: 'Integration and Job Health',
}

export function AdminPlaceholderPage() {
  const { module = '' } = useParams()
  const [ready, setReady] = useState(false)
  const [error, setError] = useState('')
  useEffect(() => { let active = true; const api = new AccountsApi(createWebApiConfiguration(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', { refreshSession: true })); void api.getAccountProfile({ accountPortal: 'admin' }).then(() => { if (active) setReady(true) }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) }); return () => { active = false } }, [])
  if (!adminPlaceholders[module]) return <Navigate to="/dashboard" replace />
  return <AdminShell activeHref={`/preview/${module}`}><h1 className="text-3xl font-semibold">{adminPlaceholders[module]}</h1>{error ? <StatusMessage tone="error">{error}</StatusMessage> : <p className="mt-6 text-text-secondary">{ready ? 'Not yet implemented' : 'Checking access…'}</p>}</AdminShell>
}
