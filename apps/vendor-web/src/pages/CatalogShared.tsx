import { AlertCircle, CheckCircle2, Clock, EyeOff, FileText, PauseCircle, ShieldCheck, XCircle } from 'lucide-react'
import { StatusBadge } from '@materyalph/web-ui'
import { statusLabel } from '../lib/vendor-status'

const statusIcons: Record<string, typeof FileText> = { DRAFT: FileText, PENDING_COMPLIANCE: Clock, PENDING_ADMIN_REVIEW: Clock, ACTIVE: CheckCircle2, INACTIVE: PauseCircle, TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED: EyeOff, REJECTED: XCircle, VERIFIED: ShieldCheck, NOT_SUBMITTED: FileText, NOT_REQUIRED: FileText, CHANGES_REQUIRED: AlertCircle }
const statusTones: Record<string, string> = { ACTIVE: 'text-status-success', VERIFIED: 'text-status-success', REJECTED: 'text-status-error', CHANGES_REQUIRED: 'text-status-error', PENDING_COMPLIANCE: 'text-status-warning', PENDING_ADMIN_REVIEW: 'text-status-warning' }
const badgeTones: Record<string, 'success' | 'warning' | 'error' | 'neutral' | 'info'> = { ACTIVE: 'success', VERIFIED: 'success', REJECTED: 'error', CHANGES_REQUIRED: 'error', PENDING_COMPLIANCE: 'warning', PENDING_ADMIN_REVIEW: 'warning', TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED: 'warning', DRAFT: 'info' }

/** Status as text plus icon; color is never the only signal. */
export function ListingState({ status, prefix }: { status: string; prefix?: string }) {
  const Icon = statusIcons[status] ?? FileText
  return <span className={`inline-flex items-center gap-1.5 font-semibold ${statusTones[status] ?? 'text-text-strong'}`}><Icon size={16} aria-hidden="true" />{prefix ? `${prefix}: ` : ''}{statusLabel(status)}</span>
}

/** Compact status pill for cards and summaries. */
export function ListingBadge({ status, prefix }: { status: string; prefix?: string }) {
  const Icon = statusIcons[status] ?? FileText
  return <StatusBadge tone={badgeTones[status] ?? 'neutral'} icon={<Icon size={14} aria-hidden="true" />} label={`${prefix ? `${prefix}: ` : ''}${statusLabel(status)}`} />
}
