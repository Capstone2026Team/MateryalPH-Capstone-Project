import { useEffect, useState, type FormEvent } from 'react'
import { useSearchParams } from 'react-router-dom'
import { CircleOff, History, Pencil, PauseCircle, PlayCircle, Zap } from 'lucide-react'
import {
  AutoAcceptPanel, Button, ConfirmDialog, ConflictBanner, DenseLedgerTable, Field, FilterChips, StaleStockBand, StatusMessage, StockLabelBadge, SummaryTiles,
  formatManilaDateTime, type AutoAcceptPanelValues, type LedgerColumn, type SummaryTile,
} from '@materyalph/web-ui'
import {
  apiFailure, configureAutoAccept, confirmStock, conflictRow, getAutoAccept, getInventorySettings, inventoryFieldErrors, listInventory, listMovements, listPriceHistory,
  pauseAutoAccept, quantityDisplay, readableInventoryError, resumeAutoAccept, saveInventorySettings, updateAllotment, updateInventoryRow,
  type AutoAcceptPolicyDetail, type InventoryLedgerMeta, type InventoryMovement, type InventoryRow, type InventorySettings, type PriceHistoryEntry, type StockLabel,
} from '../lib/inventory-api'
import { centavosToPeso, formatCentavos, pesoToCentavos } from '../lib/catalog-api'
import { statusLabel } from '../lib/vendor-status'
import { CatalogGate } from './CatalogPages'
import { useCatalogAccess } from '../lib/catalog-access'
import { ListingState, ProductsTabs } from './CatalogShared'
import { ErrorState, PageHeader } from './PhaseThreeVendorPages'

type Mode = 'edit' | 'auto' | 'history'
const REASONS = [
  { value: 'COUNT', label: 'Physical count' }, { value: 'RECEIVED', label: 'Received stock' }, { value: 'RETURNED', label: 'Customer return' },
  { value: 'DAMAGED', label: 'Damaged' }, { value: 'LOST', label: 'Lost or missing' }, { value: 'CORRECTION', label: 'Correction' },
]
const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
const confirmationText: Record<string, string> = { CONFIRMED: 'Confirmed', REMINDER: 'Confirm soon', FINAL_REMINDER: 'Final reminder', OVERDUE: 'Not confirmed', NOT_CONFIRMED: 'No count yet' }

function variantName(row: InventoryRow): string {
  return row.variantLabel ? `${row.listingName} — ${row.variantLabel}` : row.listingName
}

function AutoAcceptState({ row }: { row: InventoryRow }) {
  const policy = row.autoAccept
  if (policy.status === 'ACTIVE') return <span className="inline-flex items-center gap-1 font-semibold text-status-success"><PlayCircle size={14} aria-hidden="true" />On · {policy.remainingAllotmentQuantity} left</span>
  if (policy.status === 'PAUSED') return <span className="inline-flex items-center gap-1 font-semibold text-status-warning"><PauseCircle size={14} aria-hidden="true" />Paused</span>
  return <span className="inline-flex items-center gap-1 text-text-secondary"><CircleOff size={14} aria-hidden="true" />Off</span>
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
    <h3 className="text-base font-semibold">Edit {variantName(row)}</h3>
    {conflict && <ConflictBanner onUseCurrent={useCurrent}>
      <p>Someone saved this row after you opened it. Nothing was overwritten; your typed values are still in the form.</p>
      <dl className="mt-2 grid grid-cols-1 gap-x-6 gap-y-1 sm:grid-cols-3">
        <div><dt className="text-xs">Saved on hand</dt><dd className="font-semibold">{quantityDisplay(conflict.inventory?.quantityOnHand)} {conflict.unitCode}</dd></div>
        <div><dt className="text-xs">Saved reorder level</dt><dd className="font-semibold">{quantityDisplay(conflict.inventory?.reorderLevel)}</dd></div>
        <div><dt className="text-xs">Saved price</dt><dd className="font-semibold">{formatCentavos(conflict.price?.amountCentavos)}</dd></div>
      </dl>
    </ConflictBanner>}
    {message && <StatusMessage tone="error">{message}</StatusMessage>}
    <div className="grid min-w-0 grid-cols-1 gap-4 md:grid-cols-2">
      <Field label={`Quantity on hand (${row.unitCode})`} name="quantity_on_hand" inputMode="decimal" value={quantity} disabled={!canAdjust || busy} error={errors.quantity_on_hand} onChange={event => setQuantity(event.target.value)} hint={`Cannot be lower than the ${quantityDisplay(base.inventory?.hardReservedQuantity ?? '0')} ${row.unitCode} already reserved. Saving a count also confirms stock.`} />
      <label className="grid min-w-0 gap-2 text-sm font-semibold">Reason for the change<select className={control} value={reason} disabled={!canAdjust || busy} onChange={event => setReason(event.target.value)}>{REASONS.map(option => <option key={option.value} value={option.value}>{option.label}</option>)}</select></label>
      <Field label={`Reorder level (${row.unitCode})`} name="reorder_level" inputMode="decimal" value={reorder} disabled={!canAdjust || busy} error={errors.reorder_level} onChange={event => setReorder(event.target.value)} hint="Buyers see Limited Stock at or below this level. Empty means no Limited Stock label." />
      <Field label="Ordinary price (₱)" name="price.amount_centavos" inputMode="decimal" value={price} disabled={!canPrice || !base.price || busy} error={errors['price.amount_centavos']} onChange={event => setPrice(event.target.value)} hint={base.price ? `VAT-inclusive. Saving creates price version ${base.price.version + 1}; earlier versions stay in history.` : 'Set the first price in the product editor.'} />
      <Field label="Note (optional)" name="note" value={note} maxLength={500} disabled={!canAdjust || busy} onChange={event => setNote(event.target.value)} hint="Recorded with the movement for your team." />
    </div>
    <div className="flex flex-wrap gap-3"><Button type="submit" disabled={busy}>{busy ? 'Saving…' : 'Save row'}</Button><Button variant="secondary" disabled={busy} onClick={onCancel}>Cancel</Button></div>
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
    {detail.stock && <p className="text-sm text-text-secondary">On hand {quantityDisplay(detail.stock.quantityOnHand)} · Reserved {quantityDisplay(detail.stock.hardReservedQuantity)} · Soft-held {quantityDisplay(detail.stock.softHeldQuantity)} · Available {quantityDisplay(detail.stock.availableToSell)} {detail.unitCode}. Only you and your team see these numbers.</p>}
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    <AutoAcceptPanel unit={detail.unitCode} busy={busy} fieldErrors={fieldErrors} canConfigure={detail.permissions.canConfigure} canUpdateAllotment={detail.permissions.canUpdateAllotment}
      policy={{ status: policy.status, pauseReason: policy.pauseReason ?? null, remainingAllotment: policy.remainingAllotmentQuantity, maxUnitCount: policy.maxUnitCount ? quantityDisplay(policy.maxUnitCount) : null, maxOrderAmountPesos: policy.maxOrderAmountCentavos ? centavosToPeso(policy.maxOrderAmountCentavos) : null, lastEditor: policy.lastEditor ?? null }}
      onSave={save}
      onSaveAllotment={allotment => void run(() => updateAllotment(row.listingVariantId, policy.lockVersion, allotment.trim() || '0'), 'Allotment saved. A paused policy stays paused until the Owner or Store Manager resumes it.')}
      onPause={() => void run(() => pauseAutoAccept(row.listingVariantId, policy.lockVersion), 'Auto-accept paused.')}
      onResume={allotment => void run(() => resumeAutoAccept(row.listingVariantId, policy.lockVersion, allotment), `Auto-accept resumed with ${allotment} ${detail.unitCode}.`)} />
    {detail.versions.length > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-2 font-semibold">Policy history ({detail.versions.length})</summary>
      <ol className="grid gap-1">{detail.versions.map(version => <li key={version.version}>v{version.version} · {statusLabel(version.changeKind)} · allotment {version.remainingAllotmentQuantity} · {version.actor} · {version.createdAt ? formatManilaDateTime(version.createdAt) : ''}</li>)}</ol>
    </details>}
  </div>
}

function RowHistory({ row }: { row: InventoryRow }) {
  const [movements, setMovements] = useState<InventoryMovement[] | null>(null)
  const [prices, setPrices] = useState<PriceHistoryEntry[]>([])
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setError(null)
    Promise.all([listMovements(row.listingVariantId), listPriceHistory(row.listingVariantId)])
      .then(([loaded, history]) => { if (active) { setMovements(loaded.items); setPrices(history) } })
      .catch(async cause => { const text = await readableInventoryError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [row.listingVariantId, attempt])
  if (error) return <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
  if (!movements) return <p className="text-sm text-text-secondary" role="status">Loading history…</p>
  return <div className="grid min-w-0 gap-4 md:grid-cols-2">
    <section className="min-w-0"><h3 className="font-semibold">Stock movements</h3>
      {movements.length === 0 ? <p className="mt-2 text-sm text-text-secondary">No movements yet.</p>
        : <ol className="mt-2 grid gap-2 text-sm">{movements.map(movement => <li key={movement.id} className="border-t border-border-default pt-2"><span className="font-semibold">{statusLabel(movement.movementType)}</span> {Number(movement.quantityDelta) > 0 ? '+' : ''}{quantityDisplay(movement.quantityDelta)} → {quantityDisplay(movement.quantityOnHandAfter)} {row.unitCode}<br /><span className="text-text-secondary">{movement.actor} · {formatManilaDateTime(movement.recordedAt)}{movement.note ? ` · ${movement.note}` : ''}</span></li>)}</ol>}
    </section>
    <section className="min-w-0"><h3 className="font-semibold">Price versions</h3>
      <ol className="mt-2 grid gap-2 text-sm">{prices.map(price => <li key={price.priceVersionId} className="border-t border-border-default pt-2"><span className="font-semibold">v{price.version} {formatCentavos(price.amountCentavos)}</span> {price.priceKind === 'VOLUME_TIER' ? `from ${quantityDisplay(price.minimumQuantity)} ${row.unitCode}` : ''} · {price.current ? 'Current' : 'Retired'}<br /><span className="text-text-secondary">{price.createdBy ?? 'Vendor user'} · {formatManilaDateTime(price.effectiveAt)}</span></li>)}</ol>
    </section>
  </div>
}

function ReminderSettings() {
  const [settings, setSettings] = useState<InventorySettings | null>(null)
  const [time, setTime] = useState('08:00')
  const [email, setEmail] = useState(true)
  const [busy, setBusy] = useState(false)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  useEffect(() => {
    let active = true
    getInventorySettings().then(loaded => { if (active) { setSettings(loaded); setTime(loaded.reminderLocalTime); setEmail(loaded.emailReminders) } }).catch(() => undefined)
    return () => { active = false }
  }, [])
  if (!settings) return null
  async function save(event: FormEvent) {
    event.preventDefault()
    if (!settings) return
    setBusy(true); setNotice(null)
    try { const saved = await saveInventorySettings(settings.lockVersion, time, email); setSettings(saved); setNotice({ tone: 'success', text: 'Reminder settings saved.' }) }
    catch (cause) { setNotice({ tone: 'error', text: await readableInventoryError(cause) }) }
    finally { setBusy(false) }
  }
  return <details className="rounded-surface border border-border-default bg-surface-primary p-4">
    <summary className="min-h-11 cursor-pointer py-2 font-semibold">Stock confirmation reminders</summary>
    <form className="mt-3 grid min-w-0 gap-4 sm:grid-cols-[minmax(0,12rem)_minmax(0,1fr)_auto] sm:items-end" onSubmit={event => void save(event)}>
      <Field label="Reminder time (Asia/Manila)" name="reminder_local_time" type="time" value={time} disabled={!settings.canEdit || busy} onChange={event => setTime(event.target.value)} />
      <label className="flex min-h-12 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={email} disabled={!settings.canEdit || busy} onChange={event => setEmail(event.target.checked)} />Also email Day {settings.reminderDays.join(' and Day ')} reminders (in-app reminders are always on; no SMS)</label>
      {settings.canEdit && <Button type="submit" disabled={busy}>{busy ? 'Saving…' : 'Save reminders'}</Button>}
    </form>
    {!settings.canEdit && <p className="mt-2 text-sm text-text-secondary">The Owner or Store Manager sets the reminder time.</p>}
    {notice && <div className="mt-3"><StatusMessage tone={notice.tone}>{notice.text}</StatusMessage></div>}
  </details>
}

export function VendorInventoryPage() {
  const access = useCatalogAccess()
  const [searchParams, setSearchParams] = useSearchParams()
  const stock = (searchParams.get('stock') ?? '') as StockLabel | ''
  const confirmation = (searchParams.get('confirmation') ?? '') as 'DUE' | 'STALE' | ''
  const q = searchParams.get('q') ?? ''
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
    listInventory({ ...(q ? { q } : {}), ...(listingId ? { listingId } : {}), ...(stock ? { stock } : {}), ...(confirmation ? { confirmation } : {}), page })
      .then(result => { if (active) { setRows(result.items); setMeta(result.meta) } })
      .catch(async cause => { const text = await readableInventoryError(cause); if (active) setError(text) })
      .finally(() => { if (active) setLoading(false) })
    return () => { active = false }
  }, [ready, q, listingId, stock, confirmation, page, attempt])

  const permissions = meta?.permissions
  const counted = rows.filter(row => row.inventory !== null)
  async function confirmPage() {
    setConfirming(true); setNotice(null)
    try { await confirmStock(counted.map(row => ({ listingVariantId: row.listingVariantId, lockVersion: row.lockVersion }))); setNotice({ tone: 'success', text: `Confirmed ${counted.length} stock count${counted.length === 1 ? '' : 's'}. Hidden listings return as soon as every variant is confirmed.` }); setAttempt(value => value + 1) }
    catch (cause) { const failure = await apiFailure(cause); setNotice({ tone: 'error', text: failure?.status === 409 ? 'Some rows changed since this page loaded, so nothing was confirmed. The ledger has been refreshed; review it and confirm again.' : await readableInventoryError(cause) }); if (failure?.status === 409) setAttempt(value => value + 1) }
    finally { setConfirming(false); setConfirmOpen(false) }
  }
  function toggle(row: InventoryRow, mode: Mode) {
    setExpanded(current => current?.key === row.listingVariantId && current.mode === mode ? null : { key: row.listingVariantId, mode })
  }

  const summary = meta?.summary
  const tiles: SummaryTile[] = summary ? [
    { key: 'variants', label: 'Variants', value: summary.variants, hint: 'Active variants of your listings' },
    { key: 'out', label: 'Out of Stock', value: summary.outOfStock, hint: 'Nothing available to sell', tone: 'error' },
    { key: 'limited', label: 'Limited Stock', value: summary.limitedStock, hint: 'At or below the reorder level', tone: 'warning' },
    { key: 'due', label: 'Confirm soon', value: summary.confirmationDue, hint: 'Counted 7 to 14 days ago', tone: 'info' },
    { key: 'stale', label: 'Not confirmed', value: summary.stale, hint: 'Over 15 days: excluded from Buyers', tone: 'error' },
  ] : []
  const columns: LedgerColumn<InventoryRow>[] = [
    { key: 'product', header: 'Product / variant', cell: row => <span className="grid gap-0.5"><span className="break-words font-semibold">{variantName(row)}</span><span className="text-xs text-text-secondary">SKU {row.sku}</span>{row.listingStatus !== 'ACTIVE' && <span className="text-xs"><ListingState status={row.listingStatus} /></span>}</span> },
    { key: 'onhand', header: 'On hand', className: 'tabular-nums', cell: row => row.inventory ? <>{quantityDisplay(row.inventory.quantityOnHand)} <span className="text-text-secondary">{row.unitCode}</span></> : <span className="text-text-secondary">No count</span> },
    { key: 'reserved', header: 'Hard reserved', className: 'tabular-nums', cell: row => quantityDisplay(row.inventory?.hardReservedQuantity) },
    { key: 'soft', header: 'Soft-held', className: 'tabular-nums', cell: row => quantityDisplay(row.inventory?.softHeldQuantity) },
    { key: 'available', header: 'Available to sell', className: 'tabular-nums font-semibold', cell: row => quantityDisplay(row.inventory?.availableToSell) },
    { key: 'reorder', header: 'Reorder level', className: 'tabular-nums', cell: row => row.inventory?.reorderLevel ? quantityDisplay(row.inventory.reorderLevel) : <span className="text-text-secondary">Not set</span> },
    { key: 'public', header: 'Buyers see', cell: row => <StockLabelBadge label={row.publicLabel} prefix="" /> },
    { key: 'confirmed', header: 'Stock confirmed (Asia/Manila)', cell: row => <span className="grid gap-0.5 whitespace-nowrap"><span className={`font-semibold ${row.stockConfirmation.state === 'OVERDUE' || row.stockConfirmation.state === 'NOT_CONFIRMED' ? 'text-status-error' : row.stockConfirmation.state === 'CONFIRMED' ? '' : 'text-status-warning'}`}>{confirmationText[row.stockConfirmation.state] ?? row.stockConfirmation.state}</span><span className="text-xs text-text-secondary">{formatManilaDateTime(row.stockConfirmation.confirmedAt).replace(' (Asia/Manila)', '')}</span></span> },
    { key: 'price', header: 'Price', className: 'tabular-nums', cell: row => row.price ? <>{formatCentavos(row.price.amountCentavos)} <span className="text-xs text-text-secondary">v{row.price.version}</span></> : <span className="text-text-secondary">No price</span> },
    { key: 'auto', header: 'Auto-accept', cell: row => <AutoAcceptState row={row} /> },
    { key: 'actions', header: 'Actions', className: 'whitespace-nowrap', cell: row => <span className="flex flex-nowrap gap-1">
      {(permissions?.canAdjust || permissions?.canChangePrice) && <Button variant="quiet" aria-expanded={expanded?.key === row.listingVariantId && expanded.mode === 'edit'} onClick={() => toggle(row, 'edit')} aria-label={`Edit ${variantName(row)}`}><Pencil size={16} aria-hidden="true" /> Edit</Button>}
      {permissions?.canViewAutoAccept && <Button variant="quiet" aria-expanded={expanded?.key === row.listingVariantId && expanded.mode === 'auto'} onClick={() => toggle(row, 'auto')} aria-label={`Auto-accept for ${variantName(row)}`}><Zap size={16} aria-hidden="true" /> Auto-accept</Button>}
      <Button variant="quiet" aria-expanded={expanded?.key === row.listingVariantId && expanded.mode === 'history'} onClick={() => toggle(row, 'history')} aria-label={`History of ${variantName(row)}`}><History size={16} aria-hidden="true" /> History</Button>
    </span> },
  ]
  const lastPage = meta?.lastPage ?? 1
  const staleItems = (meta?.staleListings.items ?? []).map(item => ({ id: item.listingId, name: item.listingName, state: item.confirmation.state, hideAt: item.confirmation.hideAt, hidden: item.listingStatus === 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED' }))

  return <CatalogGate access={access} activeHref="/products">
    <div className="space-y-6">
      <PageHeader eyebrow="Store Management" title="My Products" description="Exact stock, reorder levels, counts and Item-Based auto-accept for each variant. Only your team sees these numbers; Buyers see In Stock, Limited Stock or Out of Stock." />
      <ProductsTabs active="inventory" showInventory={access.canViewInventory} />
      {!access.canViewInventory ? <StatusMessage tone="error">Your role does not include the inventory ledger. Ask the store Owner if you need stock access.</StatusMessage> : <>
        {meta && <StaleStockBand count={meta.staleListings.count} items={staleItems} renderAction={item => <Button variant="secondary" onClick={() => setParams({ listing: item.id, confirmation: '', stock: '' })}>Review<span className="sr-only"> {item.name}</span></Button>} />}
        {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
        {summary && <SummaryTiles label="Inventory summary" tiles={tiles} />}
        <div className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
          <FilterChips label="Filter by what Buyers see" value={stock} disabled={loading} onChange={value => setParams({ stock: value })} chips={[{ value: '', label: 'All stock' }, { value: 'IN_STOCK', label: 'In Stock' }, { value: 'LIMITED_STOCK', label: 'Limited Stock' }, { value: 'OUT_OF_STOCK', label: 'Out of Stock' }]} />
          <FilterChips label="Filter by stock confirmation" value={confirmation} disabled={loading} onChange={value => setParams({ confirmation: value })} chips={[{ value: '', label: 'Any confirmation' }, { value: 'DUE', label: 'Confirmation due' }, { value: 'STALE', label: 'Not confirmed 15+ days' }]} />
          <form className="grid grid-cols-1 gap-3 sm:grid-cols-[minmax(0,1fr)_auto]" role="search" aria-label="Search inventory" onSubmit={event => { event.preventDefault(); setParams({ q: query.trim() }) }}>
            <Field label="Search product or SKU" name="q" value={query} onChange={event => setQuery(event.target.value)} />
            <div className="flex flex-wrap items-end gap-2"><Button type="submit" disabled={loading}>Search</Button>{(q || stock || confirmation || listingId) && <Button variant="secondary" disabled={loading} onClick={() => { setQuery(''); setSearchParams({}, { replace: true }) }}>Clear</Button>}</div>
          </form>
        </div>
        <ReminderSettings />
        {loading ? <div className="grid gap-2" aria-busy="true" aria-label="Loading inventory">{[0, 1, 2, 3].map(index => <div key={index} className="h-12 animate-pulse rounded-control bg-surface-primary motion-reduce:animate-none" />)}</div>
          : error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
            : rows.length === 0 ? <section className="rounded-surface border border-dashed border-border-default bg-surface-primary p-8 text-center"><h2 className="text-xl font-semibold">{q || stock || confirmation || listingId ? 'No variants match these filters.' : 'No stock to track yet.'}</h2><p className="mx-auto mt-2 max-w-md text-sm text-text-secondary">{q || stock || confirmation || listingId ? 'Clear the filters to see every variant.' : 'Add a product with a counted quantity in the Listings tab; it appears here automatically.'}</p></section>
              : <>
                <div className="flex flex-wrap items-center justify-between gap-3">
                  <p className="text-sm text-text-secondary" aria-live="polite">{meta?.total ?? rows.length} variants · Page {page} of {lastPage}</p>
                  {permissions?.canAdjust && counted.length > 0 && <Button variant="secondary" onClick={() => setConfirmOpen(true)}>Confirm counts on this page</Button>}
                </div>
                <DenseLedgerTable caption="Inventory ledger" columns={columns} rows={rows} rowKey={row => row.listingVariantId} expandedKey={expanded?.key ?? null}
                  renderExpanded={row => expanded?.mode === 'edit'
                    ? <RowEditor key={row.lockVersion} row={row} canAdjust={Boolean(permissions?.canAdjust)} canPrice={Boolean(permissions?.canChangePrice)} onCancel={() => setExpanded(null)} onSaved={(saved, text) => { setRows(current => current.map(item => item.listingVariantId === saved.listingVariantId ? saved : item)); setExpanded(null); setNotice({ tone: 'success', text }) }} />
                    : expanded?.mode === 'auto' ? <AutoAcceptEditor row={row} onChanged={next => setRows(current => current.map(item => item.listingVariantId === row.listingVariantId ? { ...item, autoAccept: next } : item))} /> : <RowHistory row={row} />} />
                {lastPage > 1 && <nav aria-label="Inventory pages" className="flex flex-wrap items-center gap-3"><Button variant="secondary" disabled={page <= 1} onClick={() => setParams({ page: String(page - 1) })}>Previous</Button><span>Page {page} of {lastPage}</span><Button variant="secondary" disabled={page >= lastPage} onClick={() => setParams({ page: String(page + 1) })}>Next</Button></nav>}
              </>}
      </>}
      <ConfirmDialog open={confirmOpen} tone="primary" title="Confirm these stock counts?" confirmLabel={`Confirm ${counted.length} count${counted.length === 1 ? '' : 's'}`} busy={confirming} onCancel={() => setConfirmOpen(false)} onConfirm={() => void confirmPage()}>
        <p>You confirm that the quantity on hand shown for {counted.length} variant{counted.length === 1 ? '' : 's'} on this page matches your physical stock. If any row changed in the meantime, nothing is confirmed.</p>
      </ConfirmDialog>
    </div>
  </CatalogGate>
}
