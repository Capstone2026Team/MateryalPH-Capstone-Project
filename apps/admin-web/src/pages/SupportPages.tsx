import { useMemo } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { BackNavigation, SupportClient, SupportConversation, SupportRequestList } from '@materyalph/web-ui'
import { AdminShell, PageHeader } from './PhaseThreeAdminPages'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

export function AdminSupportRequestsPage() {
  const client = useMemo(() => new SupportClient(basePath, 'admin'), [])
  const navigate = useNavigate()
  return <AdminShell activeHref="/support"><div className="grid min-w-0 gap-5"><SupportRequestList client={client} admin renderHeader={actions => <PageHeader eyebrow="Compliance & quality" title="Support Requests" description="Review and respond to private concerns from buyers, vendors and guests." actions={actions} />} onOpen={id => navigate(`/support/${id}`)} /></div></AdminShell>
}

export function AdminSupportTicketPage() {
  const { ticketId = '' } = useParams()
  const client = useMemo(() => new SupportClient(basePath, 'admin'), [])
  return <AdminShell activeHref="/support"><SupportConversation key={ticketId} client={client} ticketId={ticketId} admin navigation={<BackNavigation><Link to="/support">Back to Support Requests</Link></BackNavigation>} /></AdminShell>
}
