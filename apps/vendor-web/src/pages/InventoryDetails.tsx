import { useState, useEffect, type FormEvent } from 'react'
import { CheckCircle2, History, Pencil, Zap } from 'lucide-react'
import {
  AsyncLoading, AutoAcceptPanel, Button, QuantityField, ConfirmDialog, ConflictBanner, DateFilter, Field, Pagination, StatusMessage,
  InventoryStockDetails, StockVisibilityNotice, Toolbar, dateFilterPreset, formatManilaDateTime,
  type AutoAcceptPanelValues, type DateFilterRange,
} from '@materyalph/web-ui'
import {
  apiFailure, configureAutoAccept, confirmStock, conflictRow, getAutoAccept, inventoryFieldErrors, listMovements, listPriceHistory,
  pauseAutoAccept, quantityDisplay, readableInventoryError, resumeAutoAccept, updateAllotment, updateInventoryRow, inventoryVariantName as variantName,
  type AutoAcceptPolicyDetail, type InventoryLedgerMeta, type InventoryMovement, type InventoryRow, type PriceHistoryEntry,
} from '../lib/inventory-api'
import { centavosToPeso, formatCentavos, pesoToCentavos } from '../lib/catalog-api'
import { statusLabel } from '../lib/vendor-status'
import { ErrorState } from './PhaseThreeVendorPages'

export type InventoryDetailMode = 'edit' | 'auto' | 'history' | 'details'
const REASONS = [
  { value: 'COUNT', label: 'Physical count' }, { value: 'RECEIVED', label: 'Received stock' }, { value: 'RETURNED', label: 'Customer return' },
  { value: 'DAMAGED', label: 'Damaged' }, { value: 'LOST', label: 'Lost or missing' }, { value: 'CORRECTION', label: 'Correction' },
]
const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
/** One editor and confirmation flow for the inventory dialog and product analytics. */
export function InventoryDetails({ row, permissions, mode, onModeChange, pending = false, onSaved, onReload }: {
  row: InventoryRow
  permissions: InventoryLedgerMeta['permissions']
  mode: InventoryDetailMode
  onModeChange: (mode: InventoryDetailMode) => void
  pending?: boolean
  onSaved: (rows: InventoryRow[]) => void
  onReload: () => void
}) {
  const [confirmOpen, setConfirmOpen] = useState(false)
  const [confirming, setConfirming] = useState(false)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const busy = pending || confirming
  async function confirm() {
    if (busy || !row.inventory || !permissions.canAdjust) return
    setConfirming(true); setNotice(null)
    try {
      const saved = await confirmStock([{ listingVariantId: row.listingVariantId, lockVersion: row.lockVersion }])
      setNotice({ tone: 'success', text: 'Stock count confirmed. Listing visibility is shown below.' })
      onSaved(saved)
    } catch (cause) {
      const failure = await apiFailure(cause)
      setNotice({ tone: 'error', text: failure?.status === 409 ? 'This stock count changed. Review the refreshed values and confirm again. Nothing was confirmed.' : await readableInventoryError(cause) })
      if (failure?.status === 409) onReload()
    } finally { setConfirming(false); setConfirmOpen(false) }
  }
  return <div className="grid gap-6">
    <div role="group" className="flex flex-wrap gap-2 border-b border-border-default pb-5" aria-label="Inventory actions">
      <Button variant={mode === 'details' ? 'primary' : 'secondary'} disabled={busy} aria-pressed={mode === 'details'} onClick={() => onModeChange('details')}>Stock details</Button>
      {(permissions.canAdjust || permissions.canChangePrice) && <Button variant={mode === 'edit' ? 'primary' : 'secondary'} disabled={busy} aria-label={`Edit ${variantName(row)}`} aria-pressed={mode === 'edit'} onClick={() => onModeChange('edit')}><Pencil size={16} aria-hidden="true" />Edit</Button>}
      {permissions.canViewAutoAccept && <Button variant={mode === 'auto' ? 'primary' : 'secondary'} disabled={busy} aria-label={`Auto-accept settings for ${variantName(row)}`} aria-pressed={mode === 'auto'} onClick={() => onModeChange('auto')}><Zap size={16} aria-hidden="true" />Auto-accept settings</Button>}
      <Button variant={mode === 'history' ? 'primary' : 'secondary'} disabled={busy} aria-label={`History of ${variantName(row)}`} aria-pressed={mode === 'history'} onClick={() => onModeChange('history')}><History size={16} aria-hidden="true" />History</Button>
      {permissions.canAdjust && row.inventory && <Button variant="secondary" disabled={busy} onClick={() => setConfirmOpen(true)}><CheckCircle2 size={16} aria-hidden="true" />{confirming ? 'Confirming…' : 'Confirm stock'}</Button>}
    </div>
    {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
    <StockVisibilityNotice blockers={row.listingVisibilityBlockers} />
    <InventoryStockDetails row={row} showQuantities={mode === 'details'} />
    {mode === 'edit' ? <RowEditor key={`${row.listingVariantId}-${row.lockVersion}`} row={row} canAdjust={permissions.canAdjust} canPrice={permissions.canChangePrice} onCancel={() => onModeChange('details')} onSaved={(saved, text) => { onModeChange('details'); setNotice({ tone: 'success', text }); onSaved([saved]) }} />
      : mode === 'auto' ? <AutoAcceptEditor key={row.listingVariantId} row={row} onChanged={autoAccept => onSaved([{ ...row, autoAccept }])} />
        : mode === 'history' ? <RowHistory key={row.listingVariantId} row={row} /> : null}
    {!row.inventory && permissions.canAdjust && <p className="text-sm text-text-secondary">Record a physical count using Edit before confirming stock.</p>}
    <ConfirmDialog open={confirmOpen} tone="primary" title="Confirm this stock count?" confirmLabel="Confirm count" busy={confirming} onCancel={() => setConfirmOpen(false)} onConfirm={() => void confirm()}>
      <p>Confirm that the quantity on hand for {variantName(row)} matches your physical stock: <strong>{quantityDisplay(row.inventory?.quantityOnHand)} {row.unitCode}</strong>. If the count is different, cancel and edit it first.</p>
      <p className="mt-2">A hidden listing returns to Buyers when every active variant is confirmed and its other requirements are complete.</p>
    </ConfirmDialog>
  </div>
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
      <QuantityField unitCode={row.unitCode} policy={row.quantityPolicy} label={`Quantity on hand (${row.unitCode})`} name="quantity_on_hand" inputMode="decimal" value={quantity} disabled={!canAdjust || busy} error={errors.quantity_on_hand} onChange={event => setQuantity(event.target.value)} hint={`Cannot be lower than the ${quantityDisplay(base.inventory?.hardReservedQuantity ?? '0')} ${row.unitCode} already reserved. Saving a count also confirms stock.`} />
      <label className="grid min-w-0 gap-2 text-sm font-semibold">Reason for the change<select className={control} value={reason} disabled={!canAdjust || busy} onChange={event => setReason(event.target.value)}>{REASONS.map(option => <option key={option.value} value={option.value}>{option.label}</option>)}</select></label>
      <QuantityField unitCode={row.unitCode} policy={row.quantityPolicy} label={`Reorder level (${row.unitCode})`} name="reorder_level" inputMode="decimal" value={reorder} disabled={!canAdjust || busy} error={errors.reorder_level} onChange={event => setReorder(event.target.value)} hint="Buyers see Limited Stock at or below this level. Empty means no Limited Stock label." />
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
  if (!detail) return <AsyncLoading compact label="Loading auto-accept…" />
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
  const [range, setRange] = useState(() => dateFilterPreset(30))
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
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !movements ? <AsyncLoading compact label="Loading history…" /> : <div className="grid min-w-0 gap-6 md:grid-cols-2 md:gap-0 md:divide-x md:divide-border-default">
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

