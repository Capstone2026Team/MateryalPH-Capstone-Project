import { Package, CheckCircle2, AlertTriangle, XCircle, Settings2 } from 'lucide-react'
import { useEffect, useState, type FormEvent } from 'react'
import { useSearchParams } from 'react-router-dom'
import { History, Pencil, Zap } from 'lucide-react'
import {
  ALL_DATES, AutoAcceptPanel, Button, ConfirmDialog, ConflictBanner, DateFilter, DenseLedgerTable, Field, Pagination, Select, SidePanel, StaleStockBand, StatusMessage, StockLabelBadge, StatCard, ActiveFilters, FormDialog, Toolbar, InfoNote, EmptyState,
  dateFilterLabel, formatManilaDateTime, type AutoAcceptPanelValues, type DateFilterRange, type LedgerColumn,
} from '@materyalph/web-ui'
import {
  apiFailure, configureAutoAccept, confirmStock, conflictRow, getAutoAccept, getInventorySettings, inventoryFieldErrors, listInventory, listMovements, listPriceHistory,
  pauseAutoAccept, quantityDisplay, readableInventoryError, resumeAutoAccept, saveInventorySettings, updateAllotment, updateInventoryRow,
  type AutoAcceptPolicyDetail, type InventoryLedgerMeta, type InventoryMovement, type InventoryRow, type InventorySettings, type PriceHistoryEntry, type StockLabel,
} from '../lib/inventory-api'
import { getCatalogTaxonomy, type CatalogTaxonomy, centavosToPeso, formatCentavos, pesoToCentavos } from '../lib/catalog-api'
import { statusLabel } from '../lib/vendor-status'
import { CatalogGate } from './CatalogPages'
import { useCatalogAccess } from '../lib/catalog-access'
import { ListingBadge, ListingState, ProductsTabs, ProductActions } from './CatalogShared'
import { CatalogProductPhoto } from '../components/CatalogProductPhoto'
import { ErrorState, PageHeader } from './PhaseThreeVendorPages'

type Mode = 'edit' | 'auto' | 'history' | 'details'
const REASONS = [
  { value: 'COUNT', label: 'Physical count' }, { value: 'RECEIVED', label: 'Received stock' }, { value: 'RETURNED', label: 'Customer return' },
  { value: 'DAMAGED', label: 'Damaged' }, { value: 'LOST', label: 'Lost or missing' }, { value: 'CORRECTION', label: 'Correction' },
]
const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const confirmationText: Record<string, string> = { CONFIRMED: 'Confirmed', REMINDER: 'Confirm soon', FINAL_REMINDER: 'Final reminder', OVERDUE: 'Not confirmed', NOT_CONFIRMED: 'No count yet' }

function variantName(row: InventoryRow): string {
  return row.variantLabel ? `${row.listingName} — ${row.variantLabel}` : row.listingName
}

/** Inline row editor. A stale version keeps the typed values and shows the saved values beside them. */
function RowEditor({ row, canAdjust, canPrice, onSaved, onCancel }: { row: InventoryRow; canAdjust: boolean; canPrice: boolean; onSaved: (row: InventoryRow, message: string) => void; onCancel: () => void }) {
  const [base, setBase] = useState(row)
  const [quantity, setQuantity] = useState(row.inventory?.quantityOnHand ? quantityDisplay(row.inventory.quantityOnHand) : '')
  const [reason, setReason] = useState('COUNT')
  const [note, setNote] = useState('')
  const [reorder, setReorder] = useState(row.inventory?.reorderLevel ? quantityDisplay(row.inventory.reorderLevel) : '')
  const [price, setPrice] = useState(row.price ? centavosToPeso(row.price.amountCentavos) : '')
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [conflict, setConflict] = useState<InventoryRow | null>(null)
  const [busy, setBusy] = useState(false)
  const originalQuantity = base.inventory ? quantityDisplay(base.inventory.quantityOnHand) : ''
  const originalReorder = base.inventory?.reorderLevel ? quantityDisplay(base.inventory.reorderLevel) : ''
  const originalPrice = base.price ? centavosToPeso(base.price.amountCentavos) : ''

  async function submit(event: FormEvent) {
    event.preventDefault()
    const local: Record<string, string> = {}
    const update: Parameters<typeof updateInventoryRow>[1] = { lockVersion: base.lockVersion }
    if (canAdjust && quantity.trim() !== originalQuantity) {
      if (!/^\d{1,14}(\.\d{1,4})?$/.test(quantity.trim())) local.quantity_on_hand = 'Enter a counted quantity of zero or more, with up to four decimals.'
      update.quantityOnHand = quantity.trim(); update.reasonCode = reason as NonNullable<typeof update.reasonCode>; update.note = note.trim() || null
    }
    if (canAdjust && reorder.trim() !== originalReorder) {
      if (reorder.trim() !== '' && !/^\d{1,14}(\.\d{1,4})?$/.test(reorder.trim())) local.reorder_level = 'Enter a reorder level of zero or more, or leave it empty.'
      update.reorderLevel = reorder.trim() === '' ? null : reorder.trim()
    }
    if (canPrice && base.price && price.trim() !== originalPrice) {
      const centavos = pesoToCentavos(price)
      if (centavos === null) local['price.amount_centavos'] = 'Enter a price above ₱0.00 with up to two decimals.'
      else update.price = { expectedPriceVersionId: base.price.priceVersionId, amountCentavos: centavos }
    }
    setErrors(local); setMessage(null)
    if (Object.keys(local).length) return
    if (Object.keys(update).length === 1) { setMessage('Change the count, reorder level or price before saving.'); return }
    setBusy(true)
    try {
      const saved = await updateInventoryRow(row.listingVariantId, update)
      onSaved(saved, `${variantName(saved)} saved.${update.price ? ' A new price version was published.' : ''}`)
    } catch (cause) {
      const failure = await apiFailure(cause)
      const current = conflictRow(failure)
      if (failure?.status === 409 && current) setConflict(current)
      else { setErrors(await inventoryFieldErrors(cause)); setMessage(await readableInventoryError(cause)) }
    } finally { setBusy(false) }
  }

  function useCurrent() {
    if (!conflict) return
    setBase(conflict); setConflict(null)
    setQuantity(conflict.inventory ? quantityDisplay(conflict.inventory.quantityOnHand) : '')
    setReorder(conflict.inventory?.reorderLevel ? quantityDisplay(conflict.inventory.reorderLevel) : '')
    setPrice(conflict.price ? centavosToPeso(conflict.price.amountCentavos) : '')
  }

  return <form className="grid min-w-0 gap-4" onSubmit={event => void submit(event)} aria-label={`Edit ${variantName(row)}`}>
    <h3 className="text-base font-semibold">Edit stock and price</h3>
    {conflict && <ConflictBanner onUseCurrent={useCurrent}>
      <p>Someone saved this row after you opened it. Nothing was overwritten; your typed values are still in the form.</p>
      <dl className="mt-2 grid grid-cols-1 gap-x-6 gap-y-1 sm:grid-cols-3">
        <div><dt className="text-xs">Saved on hand</dt><dd className="font-semibold">{quantityDisplay(conflict.inventory?.quantityOnHand)} {conflict.unitCode}</dd></div>
        <div><dt className="text-xs">Saved reorder level</dt><dd className="font-semibold">{quantityDisplay(conflict.inventory?.reorderLevel)}</dd></div>
        <div><dt className="text-xs">Saved price</dt><dd className="font-semibold">{formatCentavos(conflict.price?.amountCentavos)}</dd></div>
      </dl>
    </ConflictBanner>}
    {message && <StatusMessage tone="error">{message}</StatusMessage>}
    <div className="grid min-w-0 grid-cols-1 items-start gap-x-6 gap-y-5 md:grid-cols-2">
      <Field label={`Quantity on hand (${row.unitCode})`} name="quantity_on_hand" inputMode="decimal" value={quantity} disabled={!canAdjust || busy} error={errors.quantity_on_hand} onChange={event => setQuantity(event.target.value)} hint={`Cannot be lower than the ${quantityDisplay(base.inventory?.hardReservedQuantity ?? '0')} ${row.unitCode} already reserved. Saving a count also confirms stock.`} />
      <label className="grid min-w-0 gap-2 text-sm font-semibold">Reason for the change<select className={control} value={reason} disabled={!canAdjust || busy} onChange={event => setReason(event.target.value)}>{REASONS.map(option => <option key={option.value} value={option.value}>{option.label}</option>)}</select></label>
      <Field label={`Reorder level (${row.unitCode})`} name="reorder_level" inputMode="decimal" value={reorder} disabled={!canAdjust || busy} error={errors.reorder_level} onChange={event => setReorder(event.target.value)} hint="Buyers see Limited Stock at or below this level. Empty means no Limited Stock label." />
      <Field label="Ordinary price (₱)" name="price.amount_centavos" inputMode="decimal" value={price} disabled={!canPrice || !base.price || busy} error={errors['price.amount_centavos']} onChange={event => setPrice(event.target.value)} hint={base.price ? `VAT-inclusive. Saving creates price version ${base.price.version + 1}; earlier versions stay in history.` : 'Set the first price in the product editor.'} />
      <div className="md:col-span-2"><Field label="Note (optional)" name="note" value={note} maxLength={500} disabled={!canAdjust || busy} onChange={event => setNote(event.target.value)} hint="Recorded with the movement for your team." /></div>
    </div>
    <div className="flex flex-wrap gap-3 border-t border-border-default pt-4"><Button type="submit" disabled={busy}>{busy ? 'Saving…' : 'Save row'}</Button><Button variant="secondary" disabled={busy} onClick={onCancel}>Cancel</Button></div>
  </form>
}

function AutoAcceptEditor({ row, onChanged }: { row: InventoryRow; onChanged: (policy: InventoryRow['autoAccept']) => void }) {
  const [detail, setDetail] = useState<AutoAcceptPolicyDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({})
  const [busy, setBusy] = useState(false)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setError(null)
    getAutoAccept(row.listingVariantId).then(loaded => { if (active) setDetail(loaded) }).catch(async cause => { const text = await readableInventoryError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [row.listingVariantId, attempt])
  async function run(action: () => Promise<AutoAcceptPolicyDetail>, success: string) {
    setBusy(true); setNotice(null); setFieldErrors({})
    try { const next = await action(); setDetail(next); setNotice({ tone: 'success', text: success }); onChanged(next.policy) }
    catch (cause) {
      const failure = await apiFailure(cause)
      if (failure?.status === 409) { setNotice({ tone: 'error', text: failure.code === 'AUTO_ACCEPT_ALLOTMENT_CHANGED' ? 'The allotment changed after you opened this. Review the current value and confirm again.' : 'This policy changed in another session. The current version is shown below.' }); setAttempt(value => value + 1) }
      else { setFieldErrors(await inventoryFieldErrors(cause)); setNotice({ tone: 'error', text: await readableInventoryError(cause) }) }
    } finally { setBusy(false) }
  }
  if (error) return <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
  if (!detail) return <p className="text-sm text-text-secondary" role="status">Loading auto-accept…</p>
  const policy = detail.policy
  const save = (values: AutoAcceptPanelValues) => {
    const amount = values.maxOrderAmountPesos.trim() === '' ? null : pesoToCentavos(values.maxOrderAmountPesos)
    if (values.maxOrderAmountPesos.trim() !== '' && amount === null) { setFieldErrors({ max_order_amount_centavos: 'Enter an amount above ₱0.00 with up to two decimals, or leave it empty.' }); return }
    void run(() => configureAutoAccept(row.listingVariantId, { lockVersion: policy.lockVersion, enabled: values.enabled, allotmentQuantity: values.allotment.trim() || '0', maxUnitCount: values.maxUnitCount.trim() || null, maxOrderAmountCentavos: amount }), values.enabled ? 'Auto-accept saved.' : 'Auto-accept turned off. Orders wait for manual confirmation.')
  }
  return <div className="grid min-w-0 gap-3">
    {detail.stock && <div className="border-b border-border-default pb-5">
      <h3 className="text-base font-semibold">Stock available for auto-accept</h3>
      <dl className="mt-4 grid grid-cols-2 gap-4 sm:grid-cols-4">{[['On hand', detail.stock.quantityOnHand], ['Reserved', detail.stock.hardReservedQuantity], ['Soft-held', detail.stock.softHeldQuantity], ['Available', detail.stock.availableToSell]].map(([label, value]) => <div key={label} className="border-l border-border-default pl-3"><dt className="text-xs text-text-secondary">{label}</dt><dd className="mt-1 font-semibold tabular-nums">{quantityDisplay(value)} {detail.unitCode}</dd></div>)}</dl>
      <p className="mt-3 text-xs text-text-secondary">Only you and your team see these numbers.</p>
    </div>}
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    <AutoAcceptPanel unit={detail.unitCode} busy={busy} fieldErrors={fieldErrors} canConfigure={detail.permissions.canConfigure} canUpdateAllotment={detail.permissions.canUpdateAllotment}
      policy={{ status: policy.status, pauseReason: policy.pauseReason ?? null, remainingAllotment: policy.remainingAllotmentQuantity, maxUnitCount: policy.maxUnitCount ? quantityDisplay(policy.maxUnitCount) : null, maxOrderAmountPesos: policy.maxOrderAmountCentavos ? centavosToPeso(policy.maxOrderAmountCentavos) : null, lastEditor: policy.lastEditor ?? null }}
      onSave={save}
      onSaveAllotment={allotment => void run(() => updateAllotment(row.listingVariantId, policy.lockVersion, allotment.trim() || '0'), 'Allotment saved. A paused policy stays paused until the Owner or Store Manager resumes it.')}
      onPause={() => void run(() => pauseAutoAccept(row.listingVariantId, policy.lockVersion), 'Auto-accept paused.')}
      onResume={allotment => void run(() => resumeAutoAccept(row.listingVariantId, policy.lockVersion, allotment), `Auto-accept resumed with ${allotment} ${detail.unitCode}.`)} />
    {detail.versions.length > 0 && <details className="border-t border-border-default pt-3 text-sm"><summary className="min-h-11 cursor-pointer py-2 font-semibold">Policy history ({detail.versions.length})</summary>
      <ol className="grid gap-1">{detail.versions.map(version => <li key={version.version}>v{version.version} · {statusLabel(version.changeKind)} · allotment {version.remainingAllotmentQuantity} · {version.actor} · {version.createdAt ? formatManilaDateTime(version.createdAt) : ''}</li>)}</ol>
    </details>}
  </div>
}

function RowHistory({ row }: { row: InventoryRow }) {
  const [range, setRange] = useState(ALL_DATES)
  const [page, setPage] = useState(1)
  const [movementMeta, setMovementMeta] = useState<Awaited<ReturnType<typeof listMovements>>['meta'] | null>(null)
  const [movements, setMovements] = useState<InventoryMovement[] | null>(null)
  const [prices, setPrices] = useState<PriceHistoryEntry[]>([])
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setMovements(null); setError(null)
    const dates = { ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }
    Promise.all([listMovements(row.listingVariantId, page, dates), listPriceHistory(row.listingVariantId, dates)])
      .then(([loaded, history]) => { if (active) { setMovements(loaded.items); setMovementMeta(loaded.meta); setPrices(history) } })
      .catch(async cause => { const text = await readableInventoryError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [row.listingVariantId, page, range.from, range.to, attempt])
  const changeDates = (next: DateFilterRange) => { setPage(1); setRange(next) }
  return <div className="grid min-w-0 gap-5">
    <Toolbar filters={<DateFilter title="Inventory history dates" value={range} onChange={changeDates} />} />
    <ActiveFilters filters={range.from || range.to ? [{ key: 'dates', label: dateFilterLabel(range), onRemove: () => changeDates(ALL_DATES) }] : []} onClear={() => changeDates(ALL_DATES)} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !movements ? <p className="text-sm text-text-secondary" role="status">Loading history…</p> : <div className="grid min-w-0 gap-6 md:grid-cols-2 md:gap-0 md:divide-x md:divide-border-default">
    <section className="min-w-0 md:pr-6"><h3 className="font-semibold">Stock movements</h3>
      {movements.length === 0 ? <p className="mt-2 text-sm text-text-secondary">{range.from || range.to ? 'No movements in this date range.' : 'No movements yet.'}</p>
        : <ol className="mt-2 grid gap-2 text-sm">{movements.map(movement => <li key={movement.id} className="border-t border-border-default pt-2"><span className="font-semibold">{statusLabel(movement.movementType)}</span> {Number(movement.quantityDelta) > 0 ? '+' : ''}{quantityDisplay(movement.quantityDelta)} → {quantityDisplay(movement.quantityOnHandAfter)} {row.unitCode}<br /><span className="text-text-secondary">{movement.actor} · {formatManilaDateTime(movement.recordedAt)}{movement.note ? ` · ${movement.note}` : ''}</span></li>)}</ol>}
      {movementMeta && movementMeta.lastPage > 1 && <div className="mt-4"><Pagination page={page} lastPage={movementMeta.lastPage} total={movementMeta.total} onChange={setPage} /></div>}
    </section>
    <section className="min-w-0 border-t border-border-default pt-6 md:border-t-0 md:pl-6 md:pt-0"><h3 className="font-semibold">Price versions</h3>
      {prices.length === 0 ? <p className="mt-2 text-sm text-text-secondary">{range.from || range.to ? 'No price versions in this date range.' : 'No price versions yet.'}</p> : <ol className="mt-2 grid gap-2 text-sm">{prices.map(price => <li key={price.priceVersionId} className="border-t border-border-default pt-2"><span className="font-semibold">v{price.version} {formatCentavos(price.amountCentavos)}</span> {price.priceKind === 'VOLUME_TIER' ? `from ${quantityDisplay(price.minimumQuantity)} ${row.unitCode}` : ''} · {price.current ? 'Current' : 'Retired'}<br /><span className="text-text-secondary">{price.createdBy ?? 'Vendor user'} · {formatManilaDateTime(price.effectiveAt)}</span></li>)}</ol>}
    </section>
    </div>}
  </div>
}

function ReminderSettings() {
  const [settings, setSettings] = useState<InventorySettings | null>(null)
  const [time, setTime] = useState('08:00')
  const [email, setEmail] = useState(true)
  const [leadDays, setLeadDays] = useState('')
  const [leadError, setLeadError] = useState<string | undefined>(undefined)
  const [busy, setBusy] = useState(false)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  useEffect(() => {
    let active = true
    getInventorySettings().then(loaded => { if (active) { setSettings(loaded); setTime(loaded.reminderLocalTime); setEmail(loaded.emailReminders); setLeadDays(loaded.autoAcceptReadyLeadDays === null || loaded.autoAcceptReadyLeadDays === undefined ? '' : String(loaded.autoAcceptReadyLeadDays)) } }).catch(() => undefined)
    return () => { active = false }
  }, [])
  if (!settings) return null
  async function save(event: FormEvent) {
    event.preventDefault()
    if (!settings) return
    const lead = leadDays.trim() === '' ? null : Number(leadDays)
    if (lead !== null && (!Number.isInteger(lead) || lead < 0 || lead > 30)) { setLeadError('Enter a whole number of days from 0 to 30, or leave it empty.'); return }
    setBusy(true); setNotice(null); setLeadError(undefined)
    try { const saved = await saveInventorySettings(settings.lockVersion, time, email, lead); setSettings(saved); setNotice({ tone: 'success', text: 'Settings saved.' }) }
    catch (cause) { setNotice({ tone: 'error', text: await readableInventoryError(cause) }) }
    finally { setBusy(false) }
  }
  return <div>
    <form className="grid min-w-0 gap-4" onSubmit={event => void save(event)}>
      <Field label="Reminder time (Asia/Manila)" name="reminder_local_time" type="time" value={time} disabled={!settings.canEdit || busy} onChange={event => setTime(event.target.value)} />
      <label className="flex min-h-12 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={email} disabled={!settings.canEdit || busy} onChange={event => setEmail(event.target.checked)} />Also email Day {settings.reminderDays.join(' and Day ')} reminders (in-app reminders are always on; no SMS)</label>
      <div className="min-w-0"><Field label="Auto-accept ready-for-pickup lead time (days)" name="auto_accept_ready_lead_days" type="number" min={0} max={30} inputMode="numeric" value={leadDays} disabled={!settings.canEdit || busy} error={leadError} onChange={event => setLeadDays(event.target.value)} hint="An auto-accepted Self-Pickup order is ready this many days after acceptance (Philippine date). Leave empty to send every Self-Pickup order to manual review. Site Delivery is never auto-accepted." /></div>
      {settings.canEdit && <Button type="submit" variant="secondary" disabled={busy}>{busy ? 'Saving…' : 'Save settings'}</Button>}
    </form>
    {!settings.canEdit && <p className="mt-2 text-sm text-text-secondary">The Owner or Store Manager sets these values.</p>}
    {notice && <div className="mt-3"><StatusMessage tone={notice.tone}>{notice.text}</StatusMessage></div>}
  </div>
}

export function VendorInventoryPage() {
  const access = useCatalogAccess()
  const [searchParams, setSearchParams] = useSearchParams()
  const stock = (searchParams.get('stock') ?? '') as StockLabel | ''
  const confirmation = (searchParams.get('confirmation') ?? '') as 'DUE' | 'STALE' | ''
  const q = searchParams.get('q') ?? ''
  const categoryId = searchParams.get('category') ?? ''
  const [taxonomy, setTaxonomy] = useState<CatalogTaxonomy | null>(null)
  const [remindersOpen, setRemindersOpen] = useState(false)
  const [pauseTarget, setPauseTarget] = useState<InventoryRow | null>(null)
  const [pausing, setPausing] = useState(false)
  const listingId = searchParams.get('listing') ?? ''
  const page = Math.max(1, Number(searchParams.get('page') ?? '1') || 1)
  const [query, setQuery] = useState(q)
  const [rows, setRows] = useState<InventoryRow[]>([])
  const [meta, setMeta] = useState<InventoryLedgerMeta | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [expanded, setExpanded] = useState<{ key: string; mode: Mode } | null>(null)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [confirming, setConfirming] = useState(false)
  const [confirmOpen, setConfirmOpen] = useState(false)
  const ready = access.canView && access.active && access.canViewInventory

  useEffect(() => { if (!ready) return; let active = true; void getCatalogTaxonomy().then(value => { if (active) setTaxonomy(value) }).catch(() => undefined); return () => { active = false } }, [ready])
  useEffect(() => { setQuery(q) }, [q])

  const setParams = (patch: Record<string, string>) => setSearchParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('page' in patch)) next.delete('page')
    return next
  }, { replace: true })

  useEffect(() => {
    if (!ready) return
    let active = true
    setLoading(true); setError(null)
    listInventory({ ...(categoryId ? { categoryId } : {}), ...(q ? { q } : {}), ...(listingId ? { listingId } : {}), ...(stock ? { stock } : {}), ...(confirmation ? { confirmation } : {}), page })
      .then(result => { if (active) { setRows(result.items); setMeta(result.meta) } })
      .catch(async cause => { const text = await readableInventoryError(cause); if (active) setError(text) })
      .finally(() => { if (active) setLoading(false) })
    return () => { active = false }
  }, [ready, q, categoryId, listingId, stock, confirmation, page, attempt])

  const permissions = meta?.permissions
  const counted = rows.filter(row => row.inventory !== null)
  async function confirmPage() {
    setConfirming(true); setNotice(null)
    try { await confirmStock(counted.map(row => ({ listingVariantId: row.listingVariantId, lockVersion: row.lockVersion }))); setNotice({ tone: 'success', text: `Confirmed ${counted.length} stock count${counted.length === 1 ? '' : 's'}. Hidden listings return as soon as every variant is confirmed.` }); setAttempt(value => value + 1) }
    catch (cause) { const failure = await apiFailure(cause); setNotice({ tone: 'error', text: failure?.status === 409 ? 'Some rows changed since this page loaded, so nothing was confirmed. The ledger has been refreshed; review it and confirm again.' : await readableInventoryError(cause) }); if (failure?.status === 409) setAttempt(value => value + 1) }
    finally { setConfirming(false); setConfirmOpen(false) }
  }
  function toggle(row: InventoryRow, mode: Mode) {
    setExpanded({ key: row.listingVariantId, mode })
  }

  const summary = meta?.summary
  const kpis = [
    { label: 'Variants', value: summary?.variants, filter: '', icon: <Package size={18} />, hint: 'Active variants matching search, category and listing filters.' },
    { label: 'In stock', value: summary ? summary.variants - summary.limitedStock - summary.outOfStock : undefined, filter: 'IN_STOCK', icon: <CheckCircle2 size={18} />, hint: 'Available quantity is above the reorder level, or no level is set.' },
    { label: 'Limited stock', value: summary?.limitedStock, filter: 'LIMITED_STOCK', icon: <AlertTriangle size={18} />, hint: 'Available quantity is positive and at or below the reorder level.' },
    { label: 'Out of stock', value: summary?.outOfStock, filter: 'OUT_OF_STOCK', icon: <XCircle size={18} />, hint: 'No available quantity or no recorded stock count.' },
  ]
  const clearFilters = () => { setQuery(''); setSearchParams({}, { replace: true }) }
  const activeFilters = [
    ...(q ? [{ key: 'q', label: `Search: ${q}`, onRemove: () => { setQuery(''); setParams({ q: '' }) } }] : []),
    ...(stock ? [{ key: 'stock', label: statusLabel(stock), onRemove: () => setParams({ stock: '' }) }] : []),
    ...(confirmation ? [{ key: 'confirmation', label: confirmation === 'DUE' ? 'Confirmation due' : 'Not confirmed 15+ days', onRemove: () => setParams({ confirmation: '' }) }] : []),
    ...(categoryId ? [{ key: 'category', label: taxonomy?.categories.find(item => item.id === categoryId)?.name ?? 'Category', onRemove: () => setParams({ category: '' }) }] : []),
    ...(listingId ? [{ key: 'listing', label: 'Selected listing', onRemove: () => setParams({ listing: '' }) }] : []),
  ]
  const columns: LedgerColumn<InventoryRow>[] = [
    { key: 'product', header: 'Product / variant', cell: row => <span className="grid gap-2"><button type="button" aria-haspopup="dialog" aria-label={`View inventory details for ${variantName(row)}`} onClick={() => toggle(row, 'details')} className="min-h-11 rounded-control text-left font-semibold hover:text-action-primary focus-visible:outline-2 focus-visible:outline-focus-ring">{variantName(row)}</button>{row.listingStatus !== 'ACTIVE' && <ListingState status={row.listingStatus} />}</span> },
    { key: 'sku', header: 'SKU', cell: row => row.sku },
    { key: 'public', header: 'Stock status', cell: row => <StockLabelBadge label={row.publicLabel} prefix="" /> },
    { key: 'confirmed', header: 'Confirmation', cell: row => <span className="grid gap-2"><span>{confirmationText[row.stockConfirmation.state] ?? row.stockConfirmation.state}</span><span className="text-[13px] text-text-secondary">{formatManilaDateTime(row.stockConfirmation.confirmedAt)}</span></span> },
    { key: 'reorder', header: 'Reorder level', cell: row => row.inventory?.reorderLevel != null ? `${quantityDisplay(row.inventory.reorderLevel)} ${row.unitCode}` : 'Not set' },
    { key: 'auto', header: 'Auto-accept', cell: row => <div className="grid gap-2"><button type="button" role="switch" aria-checked={row.autoAccept.status === 'ACTIVE'} aria-label={`Auto-accept for ${variantName(row)}`} disabled={!permissions?.canConfigureAutoAccept} onClick={() => row.autoAccept.status === 'ACTIVE' ? setPauseTarget(row) : toggle(row, 'auto')} title={row.autoAccept.status === 'ACTIVE' ? 'Pause auto-accept' : 'Configure or resume auto-accept'} className={`inline-flex min-h-11 w-fit items-center gap-2 rounded-control px-2 disabled:opacity-60 ${row.autoAccept.status === 'ACTIVE' ? 'text-status-success' : 'text-text-secondary'}`}><span aria-hidden="true" className={`flex h-6 w-10 items-center rounded-full p-1 ${row.autoAccept.status === 'ACTIVE' ? 'justify-end bg-action-primary' : 'bg-slate-400'}`}><span className="h-4 w-4 rounded-full bg-white" /></span><span>{row.autoAccept.status === 'ACTIVE' ? 'On' : row.autoAccept.status === 'PAUSED' ? 'Paused' : 'Off'}</span></button>{row.autoAccept.status === 'ACTIVE' && <span className="text-[13px] text-text-secondary">{row.autoAccept.remainingAllotmentQuantity} left</span>}</div> },

  ]
  const selectedRow = rows.find(row => row.listingVariantId === expanded?.key)
  const lastPage = meta?.lastPage ?? 1


  return <CatalogGate access={access} activeHref="/products">
    <div className="space-y-6">
      <PageHeader eyebrow="Store Management" title="My Products" description="Monitor stock, confirmation and auto-accept for every variant." actions={<ProductActions canManage={access.canManage} primary={!expanded} />} />
      <ProductsTabs active="inventory" showInventory={access.canViewInventory} />
      {!access.canViewInventory ? <StatusMessage tone="error">Your role does not include the inventory ledger. Ask the store Owner if you need stock access.</StatusMessage> : <>
        <dl aria-label="Inventory summary" className="grid grid-cols-2 gap-4 xl:grid-cols-4">{kpis.map(item => <StatCard key={item.label} label={item.label} value={loading || error ? '—' : item.value ?? '—'} icon={<span aria-hidden="true">{item.icon}</span>} hint={item.hint} active={stock === item.filter} onClick={() => setParams({ stock: item.filter })} />)}</dl>
        <Toolbar searchFirst search={{ label: 'Search product or SKU', placeholder: 'Product or SKU', value: query, onChange: setQuery, maxLength: 120, onSubmit: event => { event.preventDefault(); setParams({ q: query.trim() }) } }} filters={<>
          <Select label="Stock level" hideLabel value={stock} onChange={event => setParams({ stock: event.target.value })}><option value="">All stock levels</option><option value="IN_STOCK">In stock</option><option value="LIMITED_STOCK">Limited stock</option><option value="OUT_OF_STOCK">Out of stock</option></Select>
          <Select label="Confirmation" hideLabel value={confirmation} onChange={event => setParams({ confirmation: event.target.value })}><option value="">Any confirmation</option><option value="DUE">Due</option><option value="STALE">Not confirmed 15+ days</option></Select>
          <Select label="Category" hideLabel value={categoryId} onChange={event => setParams({ category: event.target.value })}><option value="">All categories</option>{taxonomy?.categories.map(item => <option key={item.id} value={item.id}>{item.name}</option>)}</Select>
        </>} viewToggle={<Button variant="secondary" onClick={() => setRemindersOpen(true)}><Settings2 size={16} aria-hidden="true" />Reminders</Button>} />
        <ActiveFilters filters={activeFilters} onClear={clearFilters} />
        <InfoNote dismissible>Exact stock is private to your team. Buyers see In Stock, Limited Stock or Out of Stock.</InfoNote>
        {meta && meta.staleListings.count > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-3">Stock confirmation alerts</summary><StaleStockBand count={meta.staleListings.count} items={meta.staleListings.items.map(item => ({ id: item.listingId, name: item.listingName, state: item.confirmation.state, hideAt: item.confirmation.hideAt, hidden: item.listingStatus === 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED' }))} renderAction={item => <Button variant="secondary" onClick={() => setParams({ listing: item.id, confirmation: '', stock: '' })}>Review<span className="sr-only"> {item.name}</span></Button>} /></details>}
        {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
        {remindersOpen && <SidePanel open title="Reminders" description="Stock reminders and auto-accept pickup date" onClose={() => setRemindersOpen(false)}><ReminderSettings /></SidePanel>}
        {loading ? <div className="grid gap-2" aria-busy="true" aria-label="Loading inventory">{[0, 1, 2, 3].map(index => <div key={index} className="h-12 animate-pulse rounded-control bg-surface-primary motion-reduce:animate-none" />)}</div>
          : error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
            : rows.length === 0 ? <EmptyState message={q || stock || confirmation || listingId || categoryId ? 'No variants match these filters.' : 'No stock to track yet.'} action={<Button variant="secondary" onClick={() => { setQuery(''); setSearchParams({}, { replace: true }); setAttempt(value => value + 1) }}>Reset filters</Button>} />
              : <>
                <div className="flex flex-wrap items-center justify-between gap-3">
                  {permissions?.canAdjust && counted.length > 0 && <Button variant="secondary" onClick={() => setConfirmOpen(true)}>Confirm counts on this page</Button>}
                </div>
                <DenseLedgerTable responsive caption="Inventory ledger" columns={columns} rows={rows} rowKey={row => row.listingVariantId} onRowClick={row => toggle(row, 'details')} />
                {lastPage > 1 && <Pagination page={page} lastPage={lastPage} total={meta?.total ?? 0} busy={loading} onChange={next => setParams({ page: String(next) })} />}
              </>}
      </>}
      {ready && !loading && !error && selectedRow && expanded && <FormDialog open title={variantName(selectedRow)} description={`SKU: ${selectedRow.sku}`} onClose={() => setExpanded(null)} footer={null}
        headerMedia={<CatalogProductPhoto key={selectedRow.listingId} listingId={selectedRow.listingId} />}
        headerDetails={<dl aria-label="Product status" className="flex flex-wrap gap-x-5 gap-y-3 text-sm">
          <div><dt className="mb-1 text-xs text-text-secondary">Stock status</dt><dd><StockLabelBadge label={selectedRow.publicLabel} prefix="" /></dd></div>
          <div><dt className="mb-1 text-xs text-text-secondary">Listing status</dt><dd><ListingBadge status={selectedRow.listingStatus} /></dd></div>
        </dl>}>
        {(() => {
          const row = selectedRow
          return <div className="grid gap-6">
            <div role="group" className="flex flex-wrap gap-2 border-b border-border-default pb-5" aria-label="Inventory actions">
              <Button variant={expanded?.mode === 'details' ? 'primary' : 'secondary'} aria-pressed={expanded?.mode === 'details'} onClick={() => toggle(row, 'details')}>Stock details</Button>
              {(permissions?.canAdjust || permissions?.canChangePrice) && <Button variant={expanded?.mode === 'edit' ? 'primary' : 'secondary'} aria-label={`Edit ${variantName(row)}`} aria-pressed={expanded?.mode === 'edit'} onClick={() => toggle(row, 'edit')}><Pencil size={16} aria-hidden="true" />Edit</Button>}
              {permissions?.canViewAutoAccept && <Button variant={expanded?.mode === 'auto' ? 'primary' : 'secondary'} aria-label={`Auto-accept settings for ${variantName(row)}`} aria-pressed={expanded?.mode === 'auto'} onClick={() => toggle(row, 'auto')}><Zap size={16} aria-hidden="true" />Auto-accept settings</Button>}
              <Button variant={expanded?.mode === 'history' ? 'primary' : 'secondary'} aria-label={`History of ${variantName(row)}`} aria-pressed={expanded?.mode === 'history'} onClick={() => toggle(row, 'history')}><History size={16} aria-hidden="true" />History</Button>
            </div>
            <dl aria-label="Inventory overview" className="grid gap-5 border-b border-border-default pb-6 text-sm sm:grid-cols-3">
              <div><dt className="text-xs text-text-secondary">Confirmation</dt><dd className="mt-1.5 font-semibold">{confirmationText[row.stockConfirmation.state] ?? row.stockConfirmation.state}<span className="mt-1 block text-xs font-normal text-text-secondary">{formatManilaDateTime(row.stockConfirmation.confirmedAt)}</span></dd></div>
              <div className="border-t border-border-default pt-4 sm:border-l sm:border-t-0 sm:pl-5 sm:pt-0"><dt className="text-xs text-text-secondary">Reorder level</dt><dd className="mt-1.5 font-semibold tabular-nums">{row.inventory?.reorderLevel != null ? `${quantityDisplay(row.inventory.reorderLevel)} ${row.unitCode}` : 'Not set'}</dd></div>
              <div className="border-t border-border-default pt-4 sm:border-l sm:border-t-0 sm:pl-5 sm:pt-0"><dt className="text-xs text-text-secondary">Ordinary price</dt><dd className="mt-1.5 font-semibold tabular-nums">{row.price ? formatCentavos(row.price.amountCentavos) : 'No price'}{row.price && <span className="mt-1 block text-xs font-normal text-text-secondary">Price version {row.price.version}</span>}</dd></div>
            </dl>
            {expanded?.mode === 'edit'
                    ? <RowEditor key={row.lockVersion} row={row} canAdjust={Boolean(permissions?.canAdjust)} canPrice={Boolean(permissions?.canChangePrice)} onCancel={() => toggle(row, 'details')} onSaved={(saved, text) => { setRows(current => current.map(item => item.listingVariantId === saved.listingVariantId ? saved : item)); setExpanded(null); setNotice({ tone: 'success', text }) }} />
                    : expanded?.mode === 'auto' ? <AutoAcceptEditor row={row} onChanged={next => setRows(current => current.map(item => item.listingVariantId === row.listingVariantId ? { ...item, autoAccept: next } : item))} /> : expanded?.mode === 'details' ? <section aria-label="Stock quantities">
                      <h3 className="text-base font-semibold">Stock quantities</h3>
                      <dl className="mt-5 grid grid-cols-2 gap-x-6 gap-y-5 lg:grid-cols-4">{[['On hand', row.inventory?.quantityOnHand], ['Hard reserved', row.inventory?.hardReservedQuantity], ['Soft-held', row.inventory?.softHeldQuantity], ['Available to sell', row.inventory?.availableToSell]].map(([label, value]) => <div key={label} className={`min-w-0 border-l-2 pl-4 ${label === 'Available to sell' ? 'border-action-primary' : 'border-border-default'}`}><dt className="text-xs text-text-secondary">{label}</dt><dd className={`mt-2 break-words text-xl font-semibold tabular-nums ${label === 'Available to sell' ? 'text-action-primary' : ''}`}>{value == null ? 'No count' : <>{quantityDisplay(value)} <span className="text-sm font-normal text-text-secondary">{row.unitCode}</span></>}</dd></div>)}</dl>
                      <p className="mt-5 text-xs text-text-secondary">Exact stock quantities are private to your team.</p>
                    </section> : <RowHistory row={row} />}
          </div>
        })()}
      </FormDialog>}
      <ConfirmDialog open={pauseTarget !== null} title="Pause auto-accept?" confirmLabel="Pause auto-accept" busy={pausing} onCancel={() => setPauseTarget(null)} onConfirm={() => void (async () => {
        if (!pauseTarget) return
        setPausing(true)
        try { const next = await pauseAutoAccept(pauseTarget.listingVariantId, pauseTarget.autoAccept.lockVersion); setRows(current => current.map(row => row.listingVariantId === pauseTarget.listingVariantId ? { ...row, autoAccept: next.policy } : row)); setPauseTarget(null); setNotice({ tone: 'success', text: 'Auto-accept paused.' }) }
        catch (cause) { setNotice({ tone: 'error', text: await readableInventoryError(cause) }) }
        finally { setPausing(false) }
      })()}><p>Future orders will wait for manual confirmation until the policy is resumed.</p></ConfirmDialog>
      <ConfirmDialog open={confirmOpen} tone="primary" title="Confirm these stock counts?" confirmLabel={`Confirm ${counted.length} count${counted.length === 1 ? '' : 's'}`} busy={confirming} onCancel={() => setConfirmOpen(false)} onConfirm={() => void confirmPage()}>
        <p>You confirm that the quantity on hand shown for {counted.length} variant{counted.length === 1 ? '' : 's'} on this page matches your physical stock. If any row changed in the meantime, nothing is confirmed.</p>
      </ConfirmDialog>
    </div>
  </CatalogGate>
}
