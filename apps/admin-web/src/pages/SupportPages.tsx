import { useMemo } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { ArrowLeft } from 'lucide-react'
import { SupportClient, SupportConversation, SupportRequestList } from '@materyalph/web-ui'
import { AdminShell, PageHeader } from './PhaseThreeAdminPages'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

export function AdminSupportRequestsPage() {
  const client = useMemo(() => new SupportClient(basePath, 'admin'), [])
  const navigate = useNavigate()
  return <AdminShell activeHref="/support"><div className="grid min-w-0 gap-5"><SupportRequestList client={client} admin renderHeader={actions => <PageHeader eyebrow="User assistance" title="Support Requests" description="Review and respond to private concerns from buyers, vendors and guests." actions={actions} />} onOpen={id => navigate(`/support/${id}`)} /></div></AdminShell>
}

export function AdminSupportTicketPage() {
  const { ticketId = '' } = useParams()
  const client = useMemo(() => new SupportClient(basePath, 'admin'), [])
  return <AdminShell activeHref="/support"><SupportConversation key={ticketId} client={client} ticketId={ticketId} admin navigation={<Link to="/support" className="inline-flex min-h-11 items-center gap-2 rounded-control text-sm font-semibold text-action-primary"><ArrowLeft size={16} aria-hidden="true" />Back to Support Requests</Link>} /></AdminShell>
}
