import { useMemo } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { SupportClient, SupportConversation, SupportRequestList } from '@materyalph/web-ui'
import { AdminShell, PageHeader } from './PhaseThreeAdminPages'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

export function AdminSupportRequestsPage() {
  const client = useMemo(() => new SupportClient(basePath, 'admin'), [])
  const navigate = useNavigate()
  return <AdminShell activeHref="/support"><div className="grid gap-6"><SupportRequestList client={client} admin renderHeader={actions => <PageHeader eyebrow="User assistance" title="Support Requests" description="Review private concerns from buyers, vendors and guests. Responses, status changes and assignments stay in the ticket history." actions={actions} />} onOpen={id => navigate(`/support/${id}`)} /></div></AdminShell>
}

export function AdminSupportTicketPage() {
  const { ticketId = '' } = useParams()
  const client = useMemo(() => new SupportClient(basePath, 'admin'), [])
  return <AdminShell activeHref="/support"><div className="grid gap-6"><Link to="/support" className="inline-flex min-h-11 items-center font-semibold text-action-primary">Back to Support Requests</Link><SupportConversation key={ticketId} client={client} ticketId={ticketId} admin /></div></AdminShell>
}
