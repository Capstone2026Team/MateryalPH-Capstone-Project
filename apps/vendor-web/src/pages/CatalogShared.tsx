import { FileSpreadsheet, Plus, AlertCircle, CheckCircle2, CircleDashed, Clock, EyeOff, FileText, Loader2, PauseCircle, ShieldCheck, XCircle } from 'lucide-react'
import { Link, useNavigate }  from 'react-router-dom'
import { Button, StatusBadge, FilterTabs } from '@materyalph/web-ui'
import type { SaveStatus } from '../lib/listing-autosave'
import { statusLabel } from '../lib/vendor-status'

const statusIcons: Record<string, typeof FileText> = { DRAFT: FileText, PENDING_COMPLIANCE: Clock, PENDING_ADMIN_REVIEW: Clock, ACTIVE: CheckCircle2, INACTIVE: PauseCircle, TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED: EyeOff, REJECTED: XCircle, VERIFIED: ShieldCheck, NOT_SUBMITTED: FileText, NOT_REQUIRED: FileText, CHANGES_REQUIRED: AlertCircle }
const statusTones: Record<string, string> = { ACTIVE: 'text-status-success', VERIFIED: 'text-status-success', REJECTED: 'text-status-error', CHANGES_REQUIRED: 'text-status-error', PENDING_COMPLIANCE: 'text-status-warning', PENDING_ADMIN_REVIEW: 'text-status-warning' }
const badgeTones: Record<string, 'success' | 'warning' | 'error' | 'neutral' | 'info'> = { ACTIVE: 'success', VERIFIED: 'success', REJECTED: 'error', CHANGES_REQUIRED: 'error', PENDING_COMPLIANCE: 'warning', PENDING_ADMIN_REVIEW: 'warning', TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED: 'warning', DRAFT: 'neutral' }

/** Status as text plus icon; color is never the only signal. */
export function ListingState({ status, prefix }: { status: string; prefix?: string }) {
  const Icon = statusIcons[status] ?? FileText
  return <span className={`inline-flex items-center gap-1.5 font-semibold ${statusTones[status] ?? 'text-text-strong'}`}><Icon size={16} aria-hidden="true" />{prefix ? `${prefix}: ` : ''}{statusLabel(status)}</span>
}

/** Sections inside My Products. The sidebar keeps its single My Products entry. */
export function ProductsTabs({ active, showInventory }: { active: 'listings' | 'inventory'; showInventory: boolean }) {
  const navigate = useNavigate()
  if (!showInventory) return null
  return <FilterTabs appearance="tabs" label="My Products sections" value={active} onChange={value => navigate(value === 'inventory' ? '/products/inventory' : '/products')} chips={[{ value: 'listings', label: 'Listings' }, { value: 'inventory', label: 'Inventory' }]} />
}

/** Compact status pill for cards and summaries. */
export function ListingBadge({ status, prefix }: { status: string; prefix?: string }) {
  const Icon = statusIcons[status] ?? FileText
  return <StatusBadge tone={badgeTones[status] ?? 'neutral'} icon={<Icon size={14} aria-hidden="true" />} label={`${prefix ? `${prefix}: ` : ''}${statusLabel(status)}`} />
}

const manualReasons = {
  LIVE: 'This listing is live, so changes reach Buyers only when you save them.',
  REGULATED: 'Changing the material, brand, model, manufacturer or country withdraws verified PS/ICC status, so save when you are sure.',
}

/** What was last saved and what is waiting, so the Vendor never has to wonder; role="status" announces changes politely. */
export function SaveStatusLine({ status, manual, onSave, onRetry }: { status: SaveStatus; manual: 'LIVE' | 'REGULATED' | null; onSave: () => void; onRetry: () => void }) {
  const time = status.kind === 'saved' && status.at ? status.at.toLocaleTimeString('en-PH', { hour: 'numeric', minute: '2-digit', timeZone: 'Asia/Manila' }) : null
  const waiting = status.kind === 'pending' || status.kind === 'incomplete' || status.kind === 'error'
  return <div className="flex flex-wrap items-center gap-3 text-sm" role="status">
    {status.kind === 'saving' && <span className="inline-flex items-center gap-2 text-text-secondary"><Loader2 size={16} className="animate-spin" aria-hidden="true" />Saving…</span>}
    {status.kind === 'saved' && <span className="inline-flex items-center gap-2 text-status-success"><CheckCircle2 size={16} aria-hidden="true" />{time ? `All changes saved · ${time}` : 'All changes saved'}</span>}
    {status.kind === 'pending' && <span className="inline-flex items-center gap-2 text-text-secondary"><CircleDashed size={16} aria-hidden="true" />{manual ? 'Unsaved changes' : 'Saving shortly…'}</span>}
    {status.kind === 'incomplete' && <span className="inline-flex items-start gap-2 text-status-warning"><AlertCircle size={16} className="mt-0.5 shrink-0" aria-hidden="true" /><span>Not saved yet: {status.reason}</span></span>}
    {status.kind === 'error' && <span className="inline-flex items-start gap-2 text-status-error"><AlertCircle size={16} className="mt-0.5 shrink-0" aria-hidden="true" /><span>Couldn’t save. {status.message}</span></span>}
    {status.kind === 'error' && <Button variant="secondary" onClick={onRetry}>Try again</Button>}
    {manual && waiting && status.kind !== 'error' && <Button onClick={onSave}>Save changes</Button>}
    {manual && status.kind === 'saved' && <span className="text-text-secondary">{manualReasons[manual]}</span>}
  </div>
}

export function ProductActions({ canManage, primary = true }: { canManage: boolean; primary?: boolean }) {
  if (!canManage) return null
  return <><Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold" to="/products/import"><FileSpreadsheet size={16} aria-hidden="true" />Bulk import</Link><Link className={`inline-flex min-h-11 items-center gap-2 rounded-control px-4 text-sm font-semibold ${primary ? 'bg-action-primary text-white' : 'border border-border-default bg-surface-primary text-text-strong'}`} to="/products/new"><Plus size={16} aria-hidden="true" />Add product</Link></>
}
