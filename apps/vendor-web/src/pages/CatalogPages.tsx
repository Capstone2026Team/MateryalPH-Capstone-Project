import { useCallback, useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Link, useLocation, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { AlertCircle, FileSpreadsheet, LayoutGrid, Layers, Package, Plus, Rows3, Trash2 } from 'lucide-react'
import { ResponseError, type CatalogListingUpdate, type ListingStatus } from '@materyalph/api-client-ts'
import { Button, ConfirmDialog, Field, FilterChips, OnboardingFlow, ResponsiveRecordList, RowErrorTable, StatusMessage, StockLabelBadge, stockLabelText, SummaryTiles, type FilterChip, type RecordColumn, type SummaryTile } from '@materyalph/web-ui'
import {
  applyImport, catalogFieldErrors, createListing, deactivateListing, deleteListing, formatCentavos, getCatalogTaxonomy, getImport,
  getImportTemplate, getListing, getMaterial, listListings, publishListing, readableCatalogError, removeListingMedia, saveVariants,
  updateListing, uploadImport, uploadListingMedia,
  type CatalogImportJob, type CatalogListing, type CatalogListingListMeta, type CatalogListingSummary, type CatalogMaterial, type CatalogMaterialMatch, type CatalogTaxonomy,
} from '../lib/catalog-api'
import { statusLabel } from '../lib/vendor-status'
import { storeName, useCatalogAccess } from '../lib/catalog-access'
import { formFromListing, listingSteps, quantityText, rowsFromListing, unitName, useMaterialSearch, usePhotoPreviews, variantClientErrors, variantInputs, type DetailsForm, type VariantRow } from '../lib/catalog-form'
import { ListingBadge, ListingState, ProductsTabs } from './CatalogShared'
import { MaterialMatchOption, MaterialStep, PhotosComplianceStep, ProductInformationStep, PublicationGate, ReviewStep } from './CatalogListingSteps'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'

const LISTING_STATUSES: ListingStatus[] = ['DRAFT', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'ACTIVE', 'INACTIVE', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'REJECTED']
const ATTENTION: ListingStatus[] = ['PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'REJECTED']

export function CatalogGate({ access, activeHref, children }: { access: ReturnType<typeof useCatalogAccess>; activeHref: string; children: ReactNode }) {
  if (access.loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading My Products…" /></VendorShell>
  if (access.error) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={access.error} onRetry={() => void access.refresh()} /></VendorShell>
  if (!access.canView) return <VendorShell activeHref={activeHref} accountLabel={storeName(access.snapshot)} navigationData={access.snapshot}><StatusMessage tone="error">Your role does not include My Products. Ask the store Owner if you need product access.</StatusMessage></VendorShell>
  if (!access.active) return <VendorShell activeHref={activeHref} accountLabel={storeName(access.snapshot)} navigationData={access.snapshot}><PageHeader eyebrow="Store Management" title="My Products" description="Listings open after Store Activation." /><div className="mt-6"><StatusMessage>Store Activation is {statusLabel(access.activation).toLowerCase()}. Products are not required to activate your store; you can add listings once activation completes. <Link className="font-semibold underline" to="/dashboard">Return to the dashboard</Link></StatusMessage></div></VendorShell>
  return <VendorShell activeHref={activeHref} accountLabel={storeName(access.snapshot)} navigationData={access.snapshot}>{children}</VendorShell>
}

function priceText(row: CatalogListingSummary): string {
  if (row.minPriceCentavos === null || row.minPriceCentavos === undefined) return 'No price yet'
  return row.minPriceCentavos === row.maxPriceCentavos ? formatCentavos(row.minPriceCentavos) : `${formatCentavos(row.minPriceCentavos)} – ${formatCentavos(row.maxPriceCentavos)}`
}

function classification(row: CatalogListingSummary): string {
  return row.categoryName ?? row.materialName ?? (row.otherLabel ? `Other: ${row.otherLabel}` : 'Not classified')
}

/** Vendor-only stock line. Buyers never see these quantities. */
function StockLine({ row, unit }: { row: CatalogListingSummary; unit: string }) {
  if (row.availableQuantity === null || row.availableQuantity === undefined) {
    return <span className="text-text-secondary">{row.publicAvailability === 'OUT_OF_STOCK' ? 'No stock count' : stockLabelText(row.publicAvailability)}</span>
  }
  const amount = quantityText(row.availableQuantity)
  return Number(row.availableQuantity) > 0
    ? <span>Available: <strong>{amount}</strong>{unit ? ` ${unit}` : ''}</span>
    : <span className="font-semibold text-status-error">Out of stock</span>
}

function ProductCard({ row, taxonomy, onDelete }: { row: CatalogListingSummary; taxonomy: CatalogTaxonomy | null; onDelete: (row: CatalogListingSummary) => void }) {
  const unit = unitName(taxonomy, row.unitCode)
  return <li className="flex min-w-0 flex-col overflow-hidden rounded-surface border border-border-default bg-surface-primary transition-shadow hover:shadow-md motion-reduce:transition-none">
    <div className="grid aspect-[16/10] place-items-center overflow-hidden bg-surface-canvas">
      {row.primaryImageUrl ? <img src={row.primaryImageUrl} alt="" loading="lazy" className="h-full w-full object-cover" /> : <span className="grid justify-items-center gap-1 text-xs text-text-secondary"><Package size={36} aria-hidden="true" />No photo yet</span>}
    </div>
    <div className="flex flex-1 flex-col gap-2 p-4">
      <h3 className="break-words font-semibold leading-snug"><Link className="hover:text-action-primary hover:underline" to={`/products/${row.id}`}>{row.displayName}</Link></h3>
      <p className="flex items-center gap-1.5 text-xs text-text-secondary"><Layers size={14} aria-hidden="true" />{classification(row)} · SKU {row.vendorSku}</p>
      <p><span className="text-lg font-semibold tabular-nums">{priceText(row)}</span>{unit && row.minPriceCentavos !== null && row.minPriceCentavos !== undefined && <span className="text-sm text-text-secondary"> / {unit}</span>}</p>
      <div className="mt-auto flex flex-wrap gap-2 pt-1"><ListingBadge status={row.status} />{row.regulated && <ListingBadge status={row.complianceStatus} prefix="PS/ICC" />}</div>
    </div>
    <div className="flex flex-wrap items-center justify-between gap-2 border-t border-border-default px-4 py-2 text-sm">
      <StockLine row={row} unit={unit} />
      <span className="flex gap-2">{row.deletable && <Button variant="quiet" aria-label={`Delete ${row.displayName}`} onClick={() => onDelete(row)}><Trash2 size={16} aria-hidden="true" /> Delete</Button>}<Link className="inline-flex min-h-11 items-center rounded-control border border-border-default px-3 font-semibold hover:bg-surface-canvas" to={`/products/${row.id}`}>Edit<span className="sr-only"> {row.displayName}</span></Link></span>
    </div>
  </li>
}

export function VendorCatalogPage() {
  const access = useCatalogAccess()
  const [searchParams, setSearchParams] = useSearchParams()
  const [taxonomy, setTaxonomy] = useState<CatalogTaxonomy | null>(null)
  const [query, setQuery] = useState(searchParams.get('q') ?? '')
  const status = searchParams.get('status') ?? ''
  const categoryId = searchParams.get('category') ?? ''
  const q = searchParams.get('q') ?? ''
  const view = searchParams.get('view') === 'table' ? 'table' : 'grid'
  const page = Math.max(1, Number(searchParams.get('page') ?? '1') || 1)
  const [rows, setRows] = useState<CatalogListingSummary[]>([])
  const [meta, setMeta] = useState<CatalogListingListMeta>({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const location = useLocation()
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(() => { const state = location.state as { notice?: string } | null; return state?.notice ? { tone: 'success', text: state.notice } : null })
  const [pendingDelete, setPendingDelete] = useState<CatalogListingSummary | null>(null)
  const [deleting, setDeleting] = useState(false)
  const ready = access.canView && access.active

  async function confirmDelete() {
    if (!pendingDelete) return
    setDeleting(true)
    try { await deleteListing(pendingDelete.id, pendingDelete.lockVersion); setNotice({ tone: 'success', text: `“${pendingDelete.displayName}” was deleted.` }); setAttempt(value => value + 1) }
    catch (cause) { setNotice({ tone: 'error', text: await readableCatalogError(cause) }) }
    finally { setDeleting(false); setPendingDelete(null) }
  }

  const setParams = (patch: Record<string, string>) => setSearchParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('page' in patch)) next.delete('page')
    return next
  }, { replace: true })

  useEffect(() => {
    if (!ready) return
    let active = true
    void getCatalogTaxonomy().then(loaded => { if (active) setTaxonomy(loaded) }).catch(() => undefined)
    return () => { active = false }
  }, [ready])
  useEffect(() => {
    if (!ready) return
    let active = true
    setLoading(true); setError(null)
    listListings({ ...(q ? { q } : {}), ...(status ? { status: status as ListingStatus } : {}), ...(categoryId ? { categoryId } : {}), page })
      .then(result => { if (active) { setRows(result.items); setMeta(result.meta) } })
      .catch(async cause => { const message = await readableCatalogError(cause); if (active) setError(message) })
      .finally(() => { if (active) setLoading(false) })
    return () => { active = false }
  }, [ready, q, status, categoryId, page, attempt])

  const counts = meta.statusCounts ?? {}
  const total = Object.values(counts).reduce((sum, value) => sum + value, 0)
  const filtered = Boolean(q || categoryId)
  const tiles: SummaryTile[] = [
    { key: 'total', label: 'Total listings', value: total, hint: filtered ? 'Matching your search' : 'Every status' },
    { key: 'active', label: 'Active', value: counts.ACTIVE ?? 0, hint: 'Offered to Buyers while in stock', tone: 'success' },
    { key: 'out', label: 'Out of stock', value: meta.activeOutOfStock ?? 0, hint: 'Active but nothing to sell — record a count', tone: 'error' },
    { key: 'attention', label: 'Needs attention', value: ATTENTION.reduce((sum, key) => sum + (counts[key] ?? 0), 0), hint: 'Pending review, hidden or rejected', tone: 'warning' },
    { key: 'draft', label: 'Draft', value: counts.DRAFT ?? 0, hint: 'Not yet published', tone: 'info' },
  ]
  const chips: FilterChip[] = [{ value: '', label: 'All', count: total }, ...LISTING_STATUSES.filter(key => key === 'ACTIVE' || key === 'DRAFT' || (counts[key] ?? 0) > 0 || key === status).map(key => ({ value: key, label: statusLabel(key), count: counts[key] ?? 0 }))]
  const columns: RecordColumn<CatalogListingSummary>[] = [
    { key: 'name', header: 'Product', cell: row => <Link className="font-semibold text-action-primary underline" to={`/products/${row.id}`}>{row.displayName}</Link> },
    { key: 'sku', header: 'Vendor SKU', cell: row => row.vendorSku },
    { key: 'status', header: 'Listing status', cell: row => <ListingState status={row.status} /> },
    { key: 'compliance', header: 'PS/ICC', cell: row => row.regulated ? <ListingState status={row.complianceStatus} /> : <span className="text-text-secondary">Not regulated</span> },
    { key: 'material', header: 'Material', cell: row => row.materialName ?? (row.otherLabel ? `Other: ${row.otherLabel}` : 'Not classified') },
    { key: 'variants', header: 'Variants', cell: row => row.variantCount },
    { key: 'price', header: 'Price', cell: row => `${priceText(row)}${row.unitCode && row.minPriceCentavos != null ? ` / ${unitName(taxonomy, row.unitCode)}` : ''}` },
    { key: 'stock', header: 'Stock (private)', cell: row => <StockLine row={row} unit={unitName(taxonomy, row.unitCode)} /> },
    { key: 'availability', header: 'Buyers see', cell: row => <StockLabelBadge label={row.publicAvailability} prefix="" /> },
    { key: 'actions', header: 'Actions', cell: row => row.deletable ? <Button variant="quiet" aria-label={`Delete ${row.displayName}`} onClick={() => setPendingDelete(row)}><Trash2 size={16} aria-hidden="true" /> Delete</Button> : <span className="text-text-secondary">—</span> },
  ]
  const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'
  const lastPage = meta.lastPage ?? 1

  return <CatalogGate access={access} activeHref="/products">
    <div className="space-y-6">
      <PageHeader eyebrow="Store Management" title="My Products" description="Listings, variants, photos and PS/ICC evidence. Regulated materials publish only after their compliance evidence is verified." actions={access.canManage ? <><Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 font-semibold" to="/products/import"><FileSpreadsheet size={16} aria-hidden="true" /> Bulk import</Link><Link className="inline-flex min-h-11 items-center gap-2 rounded-control bg-action-primary px-4 font-semibold text-white" to="/products/new"><Plus size={16} aria-hidden="true" /> Add product</Link></> : undefined} />
      <ProductsTabs active="listings" showInventory={access.canViewInventory} />
      {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
      {!error && <SummaryTiles label="Listing summary" tiles={tiles} />}
      <div className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
        <FilterChips label="Filter by listing status" chips={chips} value={status} disabled={loading} onChange={value => setParams({ status: value })} />
        <form className="grid grid-cols-1 gap-3 sm:grid-cols-[minmax(0,2fr)_minmax(0,1fr)] lg:grid-cols-[minmax(0,2fr)_minmax(0,1fr)_auto_auto]" role="search" aria-label="Search products" onSubmit={event => { event.preventDefault(); setParams({ q: query.trim() }) }}>
          <Field label="Search name or SKU" name="q" value={query} onChange={event => setQuery(event.target.value)} />
          <label className="grid min-w-0 gap-2 text-sm font-semibold">Category<select className={control} value={categoryId} onChange={event => setParams({ category: event.target.value })}><option value="">All categories</option>{taxonomy?.categories.map(category => <option key={category.id} value={category.id}>{category.name}</option>)}</select></label>
          <div className="flex items-end gap-2"><Button type="submit" disabled={loading}>Search</Button>{(q || categoryId || status) && <Button variant="secondary" disabled={loading} onClick={() => { setQuery(''); setSearchParams({ ...(view === 'table' ? { view } : {}) }, { replace: true }) }}>Clear</Button>}</div>
          <div className="flex items-end"><FilterChips label="Layout" value={view} onChange={value => setParams({ view: value === 'table' ? 'table' : '' })} chips={[{ value: 'grid', label: 'Grid', icon: <LayoutGrid size={16} aria-hidden="true" /> }, { value: 'table', label: 'Table', icon: <Rows3 size={16} aria-hidden="true" /> }]} /></div>
        </form>
      </div>
      {loading ? <div className="grid grid-cols-1 gap-4 min-[480px]:grid-cols-2 lg:grid-cols-3" aria-busy="true" aria-label="Loading products">{[0, 1, 2].map(index => <div key={index} className="h-72 animate-pulse rounded-surface bg-surface-primary motion-reduce:animate-none" />)}</div>
        : error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
          : rows.length === 0 ? <section className="rounded-surface border border-dashed border-border-default bg-surface-primary p-8 text-center"><Package size={32} className="mx-auto text-text-secondary" aria-hidden="true" /><h2 className="mt-3 text-xl font-semibold">{meta.scope === 'ASSIGNED_ONLY' ? 'No assigned products.' : q || status || categoryId ? 'No products match these filters.' : 'No products yet.'}</h2><p className="mx-auto mt-2 max-w-md text-sm text-text-secondary">{meta.scope === 'ASSIGNED_ONLY' ? 'Products appear here when they are part of fulfillment work assigned to you.' : q || status || categoryId ? 'Clear the filters to see every listing.' : 'Your store stays active without products, but Buyers can discover it only after a listing is published and in stock.'}</p>{access.canManage && !(q || status || categoryId) && <Link className="mt-4 inline-flex min-h-11 items-center gap-2 rounded-control bg-action-primary px-4 font-semibold text-white" to="/products/new"><Plus size={16} aria-hidden="true" /> Add your first product</Link>}</section>
            : <>
              <p className="text-sm text-text-secondary" aria-live="polite">{meta.total ?? rows.length} products</p>
              {view === 'table'
                ? <ResponsiveRecordList caption="Store products" rows={rows} columns={columns} rowKey={row => row.id} cardTitle={row => <Link className="text-action-primary underline" to={`/products/${row.id}`}>{row.displayName}</Link>} />
                : <ul className="grid grid-cols-1 gap-4 min-[480px]:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5" aria-label="Store products">
                  {rows.map(row => <ProductCard key={row.id} row={row} taxonomy={taxonomy} onDelete={setPendingDelete} />)}
                  {access.canManage && page >= lastPage && <li className="min-w-0"><Link to="/products/new" className="grid h-full min-h-56 place-items-center rounded-surface border-2 border-dashed border-border-default bg-brand-orange-50 p-6 text-center transition-colors hover:border-action-primary motion-reduce:transition-none"><span className="grid justify-items-center gap-2"><Plus size={28} className="text-action-primary" aria-hidden="true" /><span className="font-semibold">Add new product</span><span className="text-sm text-text-secondary">List another material for Buyers</span></span></Link></li>}
                </ul>}
              {lastPage > 1 && <nav aria-label="Product pages" className="flex flex-wrap items-center gap-3"><Button variant="secondary" disabled={page <= 1} onClick={() => setParams({ page: String(page - 1) })}>Previous</Button><span>Page {page} of {lastPage}</span><Button variant="secondary" disabled={page >= lastPage} onClick={() => setParams({ page: String(page + 1) })}>Next</Button></nav>}
            </>}
      <ConfirmDialog open={pendingDelete !== null} title="Delete this draft?" confirmLabel="Delete draft" busy={deleting} onConfirm={() => void confirmDelete()} onCancel={() => setPendingDelete(null)}>
        <p>“{pendingDelete?.displayName}” will be removed from My Products and its SKU can be used again. This can't be undone. Only drafts that were never published can be deleted.</p>
      </ConfirmDialog>
    </div>
  </CatalogGate>
}

export function VendorListingEditorPage() {
  const { listingId } = useParams()
  const navigate = useNavigate()
  const [searchParams, setSearchParams] = useSearchParams()
  const access = useCatalogAccess()
  const [taxonomy, setTaxonomy] = useState<CatalogTaxonomy | null>(null)
  const [listing, setListing] = useState<CatalogListing | null>(null)
  const [form, setForm] = useState<DetailsForm | null>(null)
  const [rows, setRows] = useState<VariantRow[]>([])
  const [material, setMaterial] = useState<CatalogMaterial | null>(null)
  const [loading, setLoading] = useState(Boolean(listingId))
  const [loadError, setLoadError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error' | 'info'; text: string } | null>(null)
  const [conflict, setConflict] = useState(false)
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({})
  const [confirmingDelete, setConfirmingDelete] = useState(false)
  const step = Math.min(Math.max(Number(searchParams.get('step') ?? '0') || 0, 0), listingSteps.length - 1)
  const ready = access.canView && access.active

  const apply = useCallback((loaded: CatalogListing) => {
    setListing(loaded); setForm(formFromListing(loaded)); setRows(rowsFromListing(loaded)); setConflict(false)
  }, [])

  const load = useCallback(async () => {
    if (!listingId) return
    setLoading(true); setLoadError(null)
    try {
      const [loadedTaxonomy, loaded] = await Promise.all([getCatalogTaxonomy(), getListing(listingId)])
      setTaxonomy(loadedTaxonomy); apply(loaded)
      setMaterial(loaded.material ? await getMaterial(loaded.material.id) : null)
    } catch (cause) { setLoadError(await readableCatalogError(cause)) } finally { setLoading(false) }
  }, [listingId, apply])
  useEffect(() => { if (ready) void load() }, [ready, load])

  async function fail(cause: unknown) {
    if (cause instanceof ResponseError && cause.response.status === 409) setConflict(true)
    setFieldErrors(await catalogFieldErrors(cause))
    setMessage({ tone: 'error', text: await readableCatalogError(cause) })
  }

  async function run(action: () => Promise<CatalogListing>, success: string) {
    setBusy(true); setMessage(null); setFieldErrors({})
    try { const updated = await action(); apply(updated); setMessage({ tone: 'success', text: success }); return updated }
    catch (cause) { await fail(cause); return null }
    finally { setBusy(false) }
  }

  function goToStep(index: number) {
    setSearchParams(index === 0 ? {} : { step: String(index) }, { replace: true })
  }

  if (!listingId) return <CatalogGate access={access} activeHref="/products"><CreateListingForm canManage={access.canManage} onCreated={created => navigate(`/products/${created.id}`, { replace: true })} /></CatalogGate>
  if (loading || !listing || !form || !taxonomy) return <CatalogGate access={access} activeHref="/products">{loadError ? <ErrorState message={loadError} onRetry={() => void load()} /> : <LoadingState label="Loading listing…" />}</CatalogGate>

  const readOnly = !listing.permissions.canManage
  const detailsUpdate = (current: CatalogListing): CatalogListingUpdate => ({
    lockVersion: current.lockVersion, displayName: form.displayName, vendorSku: form.vendorSku, description: form.description || null,
    ...(form.materialId ? { materialId: form.materialId, materialMatch: form.materialMatch } : { materialId: null, otherLabel: form.otherLabel || null, materialCategoryId: form.categoryId || null }),
    tagIds: form.tagIds, brand: form.brand || null, model: form.model || null, manufacturer: form.manufacturer || null, manufacturerAddress: form.manufacturerAddress || null,
    countryOfManufacture: form.countryOfManufacture ? form.countryOfManufacture.toUpperCase() : null, technicalAttributes: form.technicalAttributes,
  })
  const saveDraft = () => run(() => updateListing(listing.id, detailsUpdate(listing)), 'Draft saved.')

  // Details and variants are separate server writes; the fresh lock version from the first is carried
  // into the second so a variant problem never leaves the page holding a stale version.
  async function saveProductInformation() {
    if (!listing) return
    const clientErrors = variantClientErrors(rows)
    if (Object.keys(clientErrors).length) { setFieldErrors(clientErrors); setMessage({ tone: 'error', text: 'Review the highlighted variant rows and try again.' }); return }
    setBusy(true); setMessage(null); setFieldErrors({})
    try {
      const updated = await updateListing(listing.id, detailsUpdate(listing))
      setListing(updated)
      apply(await saveVariants(updated.id, updated.lockVersion, variantInputs(rows)))
      setMessage({ tone: 'success', text: 'Product information, prices and stock counts saved.' })
    } catch (cause) { await fail(cause) } finally { setBusy(false) }
  }

  async function removeListing() {
    if (!listing) return
    setBusy(true)
    try { await deleteListing(listing.id, listing.lockVersion); navigate('/products', { replace: true, state: { notice: `“${listing.displayName}” was deleted.` } }) }
    catch (cause) { setConfirmingDelete(false); await fail(cause) }
    finally { setBusy(false) }
  }

  return <CatalogGate access={access} activeHref="/products">
    <ConfirmDialog open={confirmingDelete} title="Delete this draft?" confirmLabel="Delete draft" busy={busy} onConfirm={() => void removeListing()} onCancel={() => setConfirmingDelete(false)}>
      <p>“{listing.displayName}” will be removed from My Products and its SKU can be used again. This can't be undone.</p>
    </ConfirmDialog>
    <EditorContent onDelete={() => setConfirmingDelete(true)} listing={listing} taxonomy={taxonomy} form={form} setForm={setForm} rows={rows} setRows={setRows} material={material} setMaterial={setMaterial}
      step={step} goToStep={goToStep} busy={busy} setBusy={setBusy} readOnly={readOnly} conflict={conflict} message={message} fieldErrors={fieldErrors}
      onReload={() => void load()} onSaveDraft={() => void saveDraft()} onSaveProductInformation={() => void saveProductInformation()}
      onUpload={(file, replaces) => void run(() => uploadListingMedia(listing.id, file, listing.displayName, replaces), replaces ? 'Photo replaced. The previous version is retained in history.' : 'Photo uploaded.')}
      onRemove={mediaId => void run(() => removeListingMedia(listing.id, mediaId), 'Photo removed.')}
      onComplianceSubmitted={updated => { apply(updated); setMessage({ tone: updated.complianceStatus === 'VERIFIED' ? 'success' : 'info', text: updated.complianceStatus === 'VERIFIED' ? 'Verified through an exact match with the current DTI-BPS register.' : 'Submitted for Product Compliance review. No result is an accusation; a reviewer will confirm the marking.' }) }}
      onPublish={() => void run(() => publishListing(listing.id, listing.lockVersion), 'Publication evaluated by the server.')}
      onDeactivate={reason => void run(() => deactivateListing(listing.id, listing.lockVersion, reason), 'Listing deactivated. It is no longer offered to Buyers.')} />
  </CatalogGate>
}

function EditorContent(props: {
  listing: CatalogListing; taxonomy: CatalogTaxonomy; form: DetailsForm; setForm: (form: DetailsForm) => void; rows: VariantRow[]; setRows: (rows: VariantRow[]) => void
  material: CatalogMaterial | null; setMaterial: (material: CatalogMaterial | null) => void; step: number; goToStep: (step: number) => void; busy: boolean; setBusy: (busy: boolean) => void
  readOnly: boolean; conflict: boolean; message: { tone: 'success' | 'error' | 'info'; text: string } | null; fieldErrors: Record<string, string>
  onReload: () => void; onSaveDraft: () => void; onSaveProductInformation: () => void; onUpload: (file: File, replaces: string | null) => void; onRemove: (mediaId: string) => void
  onComplianceSubmitted: (listing: CatalogListing) => void; onPublish: () => void; onDeactivate: (reason: string | null) => void; onDelete: () => void
}) {
  const { listing, taxonomy, form, step, busy, readOnly, fieldErrors } = props
  const previews = usePhotoPreviews(listing)
  const actions = readOnly ? null : step === 0 ? <Button variant="secondary" disabled={busy} onClick={props.onSaveDraft}>{busy ? 'Saving…' : 'Save draft'}</Button>
    : step === 1 ? <Button variant="secondary" disabled={busy} onClick={props.onSaveProductInformation}>{busy ? 'Saving…' : 'Save product information'}</Button> : null
  return <div className="space-y-5">
    <Link className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary" to="/products">← My Products</Link>
    <PageHeader eyebrow={`Listing · ${listing.vendorSku}`} title={listing.displayName} description={listing.regulated ? `Regulated material: ${listing.regulatedRule?.productName ?? 'DTI-BPS mandatory certification'}. It publishes only after its PS/ICC evidence is verified.` : 'Complete each step. The server decides completion and publication readiness.'} actions={<><ListingBadge status={listing.status} />{listing.permissions.canDelete && <Button variant="quiet" disabled={busy} onClick={props.onDelete}><Trash2 size={16} aria-hidden="true" /> Delete draft</Button>}</>} />
    {props.conflict && <div className="flex flex-wrap items-center gap-3 rounded-surface border border-status-warning/40 bg-amber-50 p-4 text-sm" role="alert"><AlertCircle size={18} aria-hidden="true" /><span className="flex-1">This listing changed in another session. Reload to continue; unsaved edits on this page would be replaced.</span><Button variant="secondary" onClick={props.onReload}>Reload latest version</Button></div>}
    {props.message && <StatusMessage tone={props.message.tone}>{props.message.text}</StatusMessage>}
    {readOnly && <StatusMessage>Your role can view this listing but not change product, price, inventory or compliance data.</StatusMessage>}
    <OnboardingFlow layout="rail" steps={listingSteps} current={step} onStep={props.goToStep} section={listing.completion} busy={busy} actions={actions}
      railTitle={<>Product listing<span className="block text-sm font-normal text-text-secondary">{form.displayName || listing.displayName}</span></>}
      nextLabel={next => `Continue: ${next.label}`}
      aside={<PublicationGate listing={listing} onGoTo={props.goToStep} />}>
      {step === 0 && <MaterialStep form={form} setForm={props.setForm} taxonomy={taxonomy} material={props.material} setMaterial={props.setMaterial} errors={fieldErrors} readOnly={readOnly} />}
      {step === 1 && <ProductInformationStep listing={listing} form={form} setForm={props.setForm} rows={props.rows} setRows={props.setRows} taxonomy={taxonomy} material={props.material} errors={fieldErrors} busy={busy} readOnly={readOnly} />}
      {step === 2 && <PhotosComplianceStep listing={listing} taxonomy={taxonomy} busy={busy} setBusy={props.setBusy} readOnly={readOnly} previews={previews} onUpload={props.onUpload} onRemove={props.onRemove} mediaError={fieldErrors.media ?? null} onComplianceSubmitted={props.onComplianceSubmitted} />}
      {step === 3 && <ReviewStep listing={listing} taxonomy={taxonomy} previews={previews} busy={busy} readOnly={readOnly} onGoTo={props.goToStep} onPublish={props.onPublish} onDeactivate={props.onDeactivate} />}
    </OnboardingFlow>
  </div>
}

function CreateListingForm({ canManage, onCreated }: { canManage: boolean; onCreated: (listing: CatalogListing) => void }) {
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [materialQuery, setMaterialQuery] = useState('')
  const [chosen, setChosen] = useState<CatalogMaterialMatch | null>(null)
  const [displayName, setDisplayName] = useState('')
  const [vendorSku, setVendorSku] = useState('')
  const { results, searching, error: lookupError } = useMaterialSearch(materialQuery, canManage)
  if (!canManage) return <StatusMessage tone="error">Your role cannot create listings.</StatusMessage>
  // The display name suggestion follows the chosen canonical material, or what the Vendor typed.
  const suggestion = (chosen?.name ?? materialQuery).trim().slice(0, 180)
  const acceptSuggestion = () => { if (suggestion) setDisplayName(suggestion) }
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const name = displayName.trim() || suggestion
    if (name.length < 2) { setErrors({ display_name: 'Enter the display name, or type a material name to use as a suggestion.' }); return }
    setBusy(true); setError(null); setErrors({})
    try {
      const created = await createListing(name, vendorSku)
      // A chosen canonical material is saved right away so step 1 opens with it selected.
      onCreated(chosen ? await updateListing(created.id, { lockVersion: created.lockVersion, materialId: chosen.id, materialMatch: chosen.matchType === 'FUZZY' ? 'FUZZY_CONFIRMED' : chosen.matchType }) : created)
    }
    catch (cause) { setErrors(await catalogFieldErrors(cause)); setError(await readableCatalogError(cause)) }
    finally { setBusy(false) }
  }
  return <div className="space-y-6">
    <Link className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary" to="/products">← My Products</Link>
    <PageHeader eyebrow="Store Management" title="Add product" description="Start with the material, the name Buyers will see and your SKU. Next you add details, prices, photos and any PS/ICC evidence. You can save the draft at any step." />
    <div className="grid gap-5 lg:grid-cols-[17rem_minmax(0,1fr)] lg:items-start">
      <ol className="grid gap-1 rounded-surface border border-border-default bg-surface-primary p-2 text-sm" aria-label="Listing steps after you create the draft">
        {listingSteps.map((item, index) => <li key={item.label} className="flex items-start gap-3 px-3 py-2"><span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full border border-border-default text-xs font-semibold">{index + 1}</span><span><span className="block font-semibold">{item.label}</span><span className="text-xs text-text-secondary">{item.description}</span></span></li>)}
      </ol>
      <form className="grid min-w-0 gap-4 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" onSubmit={submit} aria-busy={busy} aria-labelledby="create-listing-heading">
        <h2 id="create-listing-heading" className="text-2xl font-semibold tracking-tight">New product listing</h2>
        {error && <StatusMessage tone="error">{error}</StatusMessage>}
        <Field label="Material name" name="material_query" value={materialQuery} autoComplete="off" hint="Type the material, for example Portland cement. Matches appear as you type; choosing one fills in the category and PS/ICC rules." onChange={event => { setMaterialQuery(event.target.value); if (chosen && event.target.value !== chosen.name) setChosen(null) }} />
        <p className="sr-only" role="status">{searching ? 'Searching materials…' : results ? `${results.length} matching materials` : ''}</p>
        {lookupError && <p className="text-sm text-status-error" role="alert">{lookupError}</p>}
        {results && results.length > 0 && <fieldset className="min-w-0 overflow-hidden rounded-surface border border-border-default">
          <legend className="sr-only">Matching materials</legend>
          <ul className="divide-y divide-border-default">{results.slice(0, 6).map(match => <MaterialMatchOption key={match.id} match={match} name="create_material_choice" selected={chosen?.id === match.id} onChoose={() => { setChosen(match); setMaterialQuery(match.name) }} />)}</ul>
        </fieldset>}
        {chosen && <p className="text-sm text-text-secondary">Material: <strong className="text-text-strong">{chosen.name}</strong> · {chosen.categoryName}</p>}
        <div className="grid gap-2">
          <Field label="Display name" name="display_name" value={displayName} placeholder={suggestion || 'For example Portland Cement Type I, 40 kg bag'} maxLength={180} error={errors.display_name}
            hint={suggestion && !displayName ? 'Leave it empty to use the suggestion, or press Tab to fill it in. Vehicle or equipment rental services are not supported.' : 'The name Buyers see. Vehicle or equipment rental services are not supported.'}
            onChange={event => setDisplayName(event.target.value)}
            onKeyDown={event => { if (event.key === 'Tab' && !event.shiftKey && !displayName && suggestion) { event.preventDefault(); acceptSuggestion() } }} />
          {suggestion && displayName.trim() !== suggestion && <Button variant="quiet" className="w-fit" onClick={acceptSuggestion}>Use suggestion: {suggestion}</Button>}
        </div>
        <Field label="Vendor SKU" name="vendor_sku" value={vendorSku} required maxLength={96} error={errors.vendor_sku} onChange={event => setVendorSku(event.target.value)} />
        <Button type="submit" className="w-fit" disabled={busy}>{busy ? 'Creating…' : 'Create draft'}</Button>
      </form>
    </div>
  </div>
}

export function VendorCatalogImportPage() {
  const access = useCatalogAccess()
  const [columns, setColumns] = useState<string[]>([])
  const [job, setJob] = useState<CatalogImportJob | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [page, setPage] = useState(1)
  const ready = access.canManage && access.active
  useEffect(() => { if (ready) void getImportTemplate().then(template => setColumns(template.columns)).catch(async cause => setError(await readableCatalogError(cause))) }, [ready])
  async function upload(file: File | undefined) {
    if (!file) return
    setBusy(true); setError(null); setJob(null); setPage(1)
    try { setJob(await uploadImport(file)) } catch (cause) { setError(await readableCatalogError(cause)) } finally { setBusy(false) }
  }
  async function apply() {
    if (!job) return
    setBusy(true); setError(null)
    try { setJob(await applyImport(job.id)) } catch (cause) { setError(await readableCatalogError(cause)) } finally { setBusy(false) }
  }
  async function changePage(next: number) {
    if (!job) return
    setPage(next)
    try { setJob(await getImport(job.id, next)) } catch (cause) { setError(await readableCatalogError(cause)) }
  }
  const template = `data:text/csv;charset=utf-8,${encodeURIComponent(columns.join(',') + '\n')}`
  const applied = job?.status === 'APPLIED' || job?.status === 'APPLIED_WITH_REJECTIONS'
  const lastPage = Number(job?.rowErrorsMeta.last_page ?? 1)
  return <CatalogGate access={access} activeHref="/products">
    <div className="space-y-6">
      <Link className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary" to="/products">← My Products</Link>
      <PageHeader eyebrow="Store Management" title="Bulk import" description="Upload a CSV to create draft listings. Every row is validated first; nothing is saved until you apply the validated rows. Imported listings are never published automatically." />
      {!access.canManage ? <StatusMessage tone="error">Your role cannot import products.</StatusMessage> : <>
        <section className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-5">
          <h2 className="text-lg font-semibold">1. Prepare the spreadsheet</h2>
          <p className="text-sm text-text-secondary">Save your spreadsheet as CSV with these columns. One row is one variant; rows sharing a Vendor SKU form one listing. Prices are pesos inclusive of VAT, for example 285.50.</p>
          <p className="break-words rounded-control bg-surface-canvas p-3 font-mono text-xs">{columns.join(', ') || 'Loading template…'}</p>
          {columns.length > 0 && <a className="inline-flex min-h-11 w-fit items-center gap-2 font-semibold text-action-primary underline" href={template} download="materyalph-catalog-template.csv">Download CSV template</a>}
        </section>
        <section className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-5">
          <h2 className="text-lg font-semibold">2. Upload and validate</h2>
          <label className="grid w-fit min-w-0 max-w-full gap-2 text-sm font-semibold">CSV file<span className="font-normal text-text-secondary">Up to 2 MB and 500 rows.</span><input type="file" accept=".csv,text/csv" className="min-h-11 w-full min-w-0 text-sm" disabled={busy} onChange={event => { void upload(event.target.files?.[0]); event.target.value = '' }} /></label>
          {busy && !job && <p className="text-sm" role="status">Validating every row…</p>}
          {error && <StatusMessage tone="error">{error}</StatusMessage>}
        </section>
        {job && <section className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-5" aria-labelledby="import-result">
          <h2 id="import-result" className="text-lg font-semibold">3. {applied ? 'Import result' : 'Validation report'}</h2>
          <dl className="grid gap-3 text-sm min-[420px]:grid-cols-2 lg:grid-cols-4"><div><dt className="text-text-secondary">Rows</dt><dd className="text-xl font-semibold">{job.totalRows}</dd></div><div><dt className="text-text-secondary">Valid</dt><dd className="text-xl font-semibold">{job.validRows}</dd></div><div><dt className="text-text-secondary">Rejected</dt><dd className="text-xl font-semibold">{job.errorRows}</dd></div><div><dt className="text-text-secondary">Imported</dt><dd className="text-xl font-semibold">{job.appliedRows}</dd></div></dl>
          {job.status === 'VALIDATED' && <StatusMessage>All {job.validRows} rows passed validation. Nothing is saved until you apply them.</StatusMessage>}
          {job.status === 'HAS_ERRORS' && <StatusMessage tone="error">{job.errorRows} of {job.totalRows} rows have problems. Nothing is saved yet. Fix the file and upload it again, or apply only the {job.validRows} valid rows — the rejected rows will not be imported.</StatusMessage>}
          {job.status === 'APPLIED' && <StatusMessage tone="success">Imported {job.appliedRows} rows as draft listings. Review each draft before publishing.</StatusMessage>}
          {job.status === 'APPLIED_WITH_REJECTIONS' && <StatusMessage tone="error">Partially imported: {job.appliedRows} rows became draft listings and {job.errorRows} rows were not imported. Correct the rejected rows below and import them again.</StatusMessage>}
          {!applied && job.validRows > 0 && <Button className="w-fit" disabled={busy} onClick={() => void apply()}>{busy ? 'Applying…' : `Apply ${job.validRows} valid row${job.validRows === 1 ? '' : 's'}`}</Button>}
          <RowErrorTable caption="Rejected rows" rows={job.rowErrors.map(row => ({ rowNumber: row.rowNumber, identifier: [row.vendorSku, row.variantSku].filter(Boolean).join(' / '), errors: row.errors }))} />
          {lastPage > 1 && <div className="flex items-center gap-3"><Button variant="secondary" disabled={page <= 1} onClick={() => void changePage(page - 1)}>Previous</Button><span>Error page {page} of {lastPage}</span><Button variant="secondary" disabled={page >= lastPage} onClick={() => void changePage(page + 1)}>Next</Button></div>}
          {applied && <Link className="inline-flex min-h-11 w-fit items-center font-semibold text-action-primary underline" to="/products?status=DRAFT">Review imported drafts</Link>}
        </section>}
      </>}
    </div>
  </CatalogGate>
}
