import { Package, CheckCircle2, AlertTriangle, XCircle, Settings2 } from 'lucide-react'
import { useEffect, useState, type FormEvent } from 'react'
import { useSearchParams } from 'react-router-dom'
import {
  Button, ConfirmDialog, DenseLedgerTable, Field, Pagination, Select, SidePanel, StaleStockBand, StatusMessage, StockLabelBadge, StockConfirmationStatus, StockVisibilityNotice, StatCard, ActiveFilters, FormDialog, Toolbar, InfoNote, EmptyState,
  type LedgerColumn,
} from '@materyalph/web-ui'
import {
  apiFailure, confirmStock, getInventorySettings, listInventory, inventoryVariantName as variantName,
  pauseAutoAccept, quantityDisplay, readableInventoryError, saveInventorySettings,
  type InventoryLedgerMeta, type InventoryRow, type InventorySettings, type StockLabel,
} from '../lib/inventory-api'
import { getCatalogTaxonomy, type CatalogTaxonomy } from '../lib/catalog-api'
import { statusLabel } from '../lib/vendor-status'
import { CatalogGate } from './CatalogPages'
import { useCatalogAccess } from '../lib/catalog-access'
import { ListingBadge, ProductsTabs, ProductActions } from './CatalogShared'
import { CatalogProductPhoto } from '../components/CatalogProductPhoto'
import { ErrorState, PageHeader } from './PhaseThreeVendorPages'
import { InventoryDetails, type InventoryDetailMode } from './InventoryDetails'

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
  const [expanded, setExpanded] = useState<{ key: string; mode: InventoryDetailMode } | null>(null)
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
  function toggle(row: InventoryRow, mode: InventoryDetailMode) {
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
    { key: 'product', header: 'Product / variant', cell: row => <div className="mp-inventory-product-cell"><button type="button" aria-haspopup="dialog" aria-label={`View inventory details for ${variantName(row)}`} aria-describedby={`inventory-sku-${row.listingVariantId}`} onClick={() => toggle(row, 'details')} className="mp-inventory-product"><span>{row.listingName}</span><span className="mp-inventory-product-meta">{row.variantLabel && <span>{row.variantLabel}</span>}<span id={`inventory-sku-${row.listingVariantId}`}>SKU <span className="text-text-strong">{row.sku}</span></span></span></button>{row.listingStatus !== 'ACTIVE' && <><ListingBadge status={row.listingStatus} /><StockVisibilityNotice blockers={row.listingVisibilityBlockers} compact /></>}</div> },
    { key: 'public', header: 'Stock status', cell: row => <StockLabelBadge label={row.publicLabel} prefix="" /> },
    { key: 'confirmed', header: 'Confirmation', cell: row => <StockConfirmationStatus confirmation={row.stockConfirmation} /> },
    { key: 'reorder', header: 'Reorder level', cell: row => row.inventory?.reorderLevel != null ? `${quantityDisplay(row.inventory.reorderLevel)} ${row.unitCode}` : 'Not set' },
    { key: 'auto', header: 'Auto-accept', cell: row => <div className="mp-inventory-auto"><button type="button" role="switch" aria-checked={row.autoAccept.status === 'ACTIVE'} aria-label={`Auto-accept for ${variantName(row)}`} disabled={!permissions?.canConfigureAutoAccept} onClick={() => row.autoAccept.status === 'ACTIVE' ? setPauseTarget(row) : toggle(row, 'auto')} title={row.autoAccept.status === 'ACTIVE' ? 'Pause auto-accept' : 'Configure or resume auto-accept'} className="mp-inventory-auto-switch"><span aria-hidden="true" className="mp-inventory-auto-track"><span /></span><span>{row.autoAccept.status === 'ACTIVE' ? 'On' : row.autoAccept.status === 'PAUSED' ? 'Paused' : 'Off'}</span></button>{row.autoAccept.status === 'ACTIVE' && <span className="text-xs text-text-secondary">{row.autoAccept.remainingAllotmentQuantity} left</span>}</div> },

  ]
  const selectedRow = rows.find(row => row.listingVariantId === expanded?.key)
  const lastPage = meta?.lastPage ?? 1


  return <CatalogGate access={access} activeHref="/products">
    <div className="mp-product-catalog">
      <PageHeader compact eyebrow="Store Management" title="My Products" description="Monitor stock, confirmation and auto-accept for every variant." actions={<ProductActions canManage={access.canManage} primary={!expanded} />} />
      <ProductsTabs active="inventory" showInventory={access.canViewInventory} />
      {!access.canViewInventory ? <StatusMessage tone="error">Your role does not include the inventory ledger. Ask the store Owner if you need stock access.</StatusMessage> : <>
        <div className="mp-product-catalog-controls">
        <dl aria-label="Inventory summary" className="mp-product-catalog-summary">{kpis.map(item => <StatCard compact key={item.label} label={item.label} value={loading || error ? '—' : item.value ?? '—'} icon={<span aria-hidden="true">{item.icon}</span>} hint={item.hint} active={stock === item.filter} onClick={() => setParams({ stock: item.filter })} />)}</dl>
        <Toolbar compact searchFirst search={{ label: 'Search product or SKU', placeholder: 'Product or SKU', value: query, onChange: setQuery, maxLength: 120, onSubmit: event => { event.preventDefault(); setParams({ q: query.trim() }) } }} filters={<>
          <Select label="Stock level" hideLabel value={stock} onChange={event => setParams({ stock: event.target.value })}><option value="">All stock levels</option><option value="IN_STOCK">In stock</option><option value="LIMITED_STOCK">Limited stock</option><option value="OUT_OF_STOCK">Out of stock</option></Select>
          <Select label="Confirmation" hideLabel value={confirmation} onChange={event => setParams({ confirmation: event.target.value })}><option value="">Any confirmation</option><option value="DUE">Due</option><option value="STALE">Not confirmed 15+ days</option></Select>
          <Select label="Category" hideLabel value={categoryId} onChange={event => setParams({ category: event.target.value })}><option value="">All categories</option>{taxonomy?.categories.map(item => <option key={item.id} value={item.id}>{item.name}</option>)}</Select>
        </>} viewToggle={<Button variant="secondary" onClick={() => setRemindersOpen(true)}><Settings2 size={16} aria-hidden="true" />Reminders</Button>} />
        <ActiveFilters filters={activeFilters} onClear={clearFilters} />
        </div>
        <InfoNote dismissible>Exact stock is private to your team. Buyers see In Stock, Limited Stock or Out of Stock.</InfoNote>
        {meta && meta.staleListings.count > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-3">Stock confirmation alerts</summary><StaleStockBand count={meta.staleListings.count} items={meta.staleListings.items.map(item => ({ id: item.listingId, name: item.listingName, state: item.confirmation.state, hideAt: item.confirmation.hideAt, hidden: item.listingStatus === 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED' }))} renderAction={item => <Button variant="secondary" onClick={() => setParams({ listing: item.id, confirmation: '', stock: '' })}>Review<span className="sr-only"> {item.name}</span></Button>} /></details>}
        {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
        {remindersOpen && <SidePanel open title="Reminders" description="Stock reminders and auto-accept pickup date" onClose={() => setRemindersOpen(false)}><ReminderSettings /></SidePanel>}
        {loading ? <div className="grid gap-2" aria-busy="true" aria-label="Loading inventory">{[0, 1, 2, 3].map(index => <div key={index} className="h-12 animate-pulse rounded-control bg-surface-primary motion-reduce:animate-none" />)}</div>
          : error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
            : rows.length === 0 ? <EmptyState message={q || stock || confirmation || listingId || categoryId ? 'No variants match these filters.' : 'No stock to track yet.'} action={<Button variant="secondary" onClick={() => { setQuery(''); setSearchParams({}, { replace: true }); setAttempt(value => value + 1) }}>Reset filters</Button>} />
              : <>
                <section aria-label="Stock ledger" className="mp-inventory-ledger mp-card">
                <div className="mp-inventory-ledger-toolbar">
                  <div><h2>Stock ledger</h2><p>{rows.length} {rows.length === 1 ? 'variant' : 'variants'} on this page</p></div>
                  {permissions?.canAdjust && counted.length > 0 && <Button variant="secondary" onClick={() => setConfirmOpen(true)}>Confirm counts on this page</Button>}
                </div>
                <DenseLedgerTable compact responsive caption="Inventory ledger" columns={columns} rows={rows} rowKey={row => row.listingVariantId} onRowClick={row => toggle(row, 'details')} />
                </section>
                {lastPage > 1 && <Pagination page={page} lastPage={lastPage} total={meta?.total ?? 0} busy={loading} onChange={next => setParams({ page: String(next) })} />}
              </>}
      </>}
      {ready && !error && selectedRow && expanded && <FormDialog open title={variantName(selectedRow)} description={`SKU: ${selectedRow.sku}`} onClose={() => setExpanded(null)} footer={null}
        headerMedia={<CatalogProductPhoto key={selectedRow.listingId} listingId={selectedRow.listingId} />}
        headerDetails={<dl aria-label="Product status" className="flex flex-wrap gap-x-5 gap-y-3 text-sm">
          <div><dt className="mb-1 text-xs text-text-secondary">Stock status</dt><dd><StockLabelBadge label={selectedRow.publicLabel} prefix="" /></dd></div>
          <div><dt className="mb-1 text-xs text-text-secondary">Listing status</dt><dd><ListingBadge status={selectedRow.listingStatus} /></dd></div>
        </dl>}>
        {permissions && <InventoryDetails row={selectedRow} permissions={permissions} mode={expanded.mode} onModeChange={mode => toggle(selectedRow, mode)} pending={loading}
          onSaved={saved => { setRows(current => current.map(row => saved.find(next => next.listingVariantId === row.listingVariantId) ?? row)); setAttempt(value => value + 1) }} onReload={() => setAttempt(value => value + 1)} />}
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
