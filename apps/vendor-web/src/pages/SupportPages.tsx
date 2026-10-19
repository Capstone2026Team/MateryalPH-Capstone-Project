import { useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import { AccountsApi, ResponseError } from '@materyalph/api-client-ts'
import { Button, createWebApiConfiguration, GuestSupportAccessForm, StatusMessage, SupportClient, SupportConversation, SupportRequestForm, SupportRequestList, type SupportIdentity } from '@materyalph/web-ui'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { BrandHeader } from '../components/BrandHeader'
import { readableApiError } from '../lib/auth-api'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

function SupportPage({ children, title }: { children: ReactNode; title: string }) {
  return <div className="min-h-screen bg-surface-canvas text-text-strong"><BrandHeader /><main id="main-content" className="mx-auto grid max-w-4xl gap-6 px-5 py-10 sm:px-8"><header><Link to="/" className="inline-flex min-h-11 items-center font-semibold text-action-primary">Back to MateryalPH</Link><h1 className="mt-3 text-3xl font-semibold">{title}</h1><p className="mt-3 max-w-2xl leading-7 text-text-secondary">Send your concern to the MateryalPH administration team. Responses and follow-ups stay in one private support ticket. This is an asynchronous support service.</p></header><div className="grid gap-8 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-8">{children}</div></main></div>
}

export function VendorContactPage() {
  const [identity, setIdentity] = useState<SupportIdentity | null | undefined>(undefined)
  const [error, setError] = useState('')
  const [attempt, setAttempt] = useState(0)
  const client = useMemo(() => new SupportClient(basePath, identity ? 'vendors' : 'guest'), [identity])
  useEffect(() => {
    let active = true
    void new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getAccountProfile({ accountPortal: 'vendors' }).then(({ data }) => {
      if (active) { setIdentity({ fullName: data.fullName, email: data.email, userType: 'VENDOR' }); setError('') }
    }).catch(async error => {
      if (!active) return
      if (error instanceof ResponseError && error.response.status === 401) setIdentity(null)
      else setError(await readableApiError(error))
    })
    return () => { active = false }
  }, [attempt])
  return <SupportPage title="Contact Us">
    {error ? <StatusMessage tone="error">{error}<Button variant="secondary" onClick={() => { setError(''); setAttempt(value => value + 1) }}>Retry account check</Button><Link className="inline-flex min-h-11 items-center px-3 underline" to="/login">Sign in</Link></StatusMessage> : identity === undefined ? <StatusMessage>Checking your account…</StatusMessage> : <>
      {identity && <Link to="/support/requests" className="inline-flex min-h-11 items-center font-semibold text-action-primary underline">My Support Requests</Link>}
      <SupportRequestForm client={client} identity={identity ?? undefined} />
      {!identity && <section className="border-t border-border-default pt-6"><GuestSupportAccessForm client={client} /></section>}
    </>}
  </SupportPage>
}

export function VendorSupportRequestsPage() {
  const navigate = useNavigate()
  const client = useMemo(() => new SupportClient(basePath, 'vendors'), [])
  return <SupportPage title="My Support Requests"><Link to="/contact" className="inline-flex min-h-11 items-center font-semibold text-action-primary underline">Submit a new concern</Link><SupportRequestList client={client} onOpen={id => navigate(`/support/${id}`)} /></SupportPage>
}

export function VendorSupportTicketPage() {
  const { ticketId = '' } = useParams()
  const client = useMemo(() => new SupportClient(basePath, 'vendors'), [])
  return <SupportPage title="Support request"><Link to="/support/requests" className="inline-flex min-h-11 items-center font-semibold text-action-primary underline">My Support Requests</Link><SupportConversation key={ticketId} client={client} ticketId={ticketId} /></SupportPage>
}

export function GuestSupportAccessPage() {
  const navigate = useNavigate()
  const client = useMemo(() => new SupportClient(basePath, 'guest'), [])
  const [token] = useState(() => new URLSearchParams(window.location.hash.slice(1)).get('token') ?? '')
  const request = useRef<ReturnType<SupportClient['exchange']> | null>(null)
  const [error, setError] = useState('')
  useEffect(() => {
    window.history.replaceState(null, '', window.location.pathname)
    if (!token) return
    let active = true
    request.current ??= client.exchange(token)
    void request.current.then(result => { if (active) navigate(`/contact/tickets/${result.data.ticketId}`, { replace: true }) }).catch(async error => { if (active) setError(await readableApiError(error)) })
    return () => { active = false }
  }, [client, token, navigate])
  return <SupportPage title="Private support access">{token && !error ? <StatusMessage>Opening your secure support session…</StatusMessage> : <>{error && <StatusMessage tone="error">{error}</StatusMessage>}<GuestSupportAccessForm client={client} /></>}</SupportPage>
}

export function GuestSupportTicketPage() {
  const { ticketId = '' } = useParams()
  const client = useMemo(() => new SupportClient(basePath, 'guest'), [])
  return <SupportPage title="Your support request"><SupportConversation key={ticketId} client={client} ticketId={ticketId} /><section className="border-t border-border-default pt-6"><GuestSupportAccessForm client={client} /></section></SupportPage>
}
