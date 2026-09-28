import { useEffect, useMemo, useRef, useState, type FormEvent } from 'react'
import { AlertCircle, Camera, Check, CheckCircle2, ClipboardList, Package, QrCode, Search, ShieldAlert, Trash2, UploadCloud } from 'lucide-react'
import type { CatalogAttributeDefinition, CompliancePath, MarkingType } from '@materyalph/api-client-ts'
import { Button, Field, MediaUploadField, RowGroup, StatusMessage, type MediaItem } from '@materyalph/web-ui'
import {
  formatCentavos, getMaterial, readableCatalogError, catalogFieldErrors, submitCompliance, uploadComplianceEvidence,
  type CatalogListing, type CatalogMaterial, type CatalogMaterialMatch, type CatalogTaxonomy, type ComplianceEvidence,
} from '../lib/catalog-api'
import { IMAGE_TYPES, MAX_TIERS, emptyVariant, groupedBlockers, quantityText, tierRange, unitName, useMaterialSearch, type DetailsForm, type TierRow, type VariantRow } from '../lib/catalog-form'
import { statusLabel } from '../lib/vendor-status'
import { ListingBadge, ListingState } from './CatalogShared'

const TAX_LABELS: Record<string, string> = { VAT_12: 'VAT 12%', VAT_ZERO: 'Zero-rated', VAT_EXEMPT: 'VAT-exempt', NON_VAT: 'Non-VAT' }
const control = 'min-h-12 w-full min-w-0 rounded-control border bg-surface-primary px-3 text-base font-normal'

function SectionHeading({ id, title, children }: { id: string; title: string; children?: string }) {
  return <div className="border-b border-border-default pb-2"><h3 id={id} className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{title}</h3>{children && <p className="mt-1 text-sm text-text-secondary">{children}</p>}</div>
}

/** One canonical-material match: name, regulated badge, category and how it matched. */
export function MaterialMatchOption({ match, name, selected, onChoose }: { match: CatalogMaterialMatch; name: string; selected: boolean; onChoose: () => void }) {
  const matchLabel = match.matchType === 'FUZZY' ? `Close match ${Math.round(match.similarity * 100)}%` : match.matchType === 'ALIAS' ? 'Alias match' : 'Exact name'
  return <li><label className={`flex min-h-14 cursor-pointer flex-wrap items-center gap-x-3 gap-y-1 px-4 py-3 ${selected ? 'bg-green-50' : 'hover:bg-surface-canvas'}`}>
    <input type="radio" name={name} className="h-5 w-5 shrink-0 accent-action-primary" checked={selected} onChange={onChoose} />
    <span className="min-w-0 flex-1"><span className="flex flex-wrap items-center gap-2"><span className="font-semibold">{match.name}</span>{match.regulated && <span className="inline-flex items-center gap-1 rounded-pill border border-amber-300 bg-amber-50 px-2 py-0.5 text-xs font-semibold text-amber-900"><ShieldAlert size={13} aria-hidden="true" />DTI-BPS regulated</span>}</span>
      <span className="block text-sm text-text-secondary">{match.categoryName}{match.regulated ? ' · PS Mark or ICC sticker required' : ' · Not regulated'}{match.matchType === 'ALIAS' ? ` · alias “${match.matchedText}”` : ''}</span></span>
    <span className={`shrink-0 rounded-pill px-2 py-0.5 text-xs font-semibold ${match.matchType === 'FUZZY' ? 'bg-amber-50 text-amber-900' : 'bg-green-100 text-green-900'}`}>{matchLabel}</span>
    {match.matchType === 'FUZZY' && <span className="basis-full pl-8 text-xs text-text-secondary">Close match to “{match.matchedText}” — confirm it is the same product before choosing it.</span>}
  </label></li>
}

export function MaterialStep({ form, setForm, taxonomy, material, setMaterial, errors, readOnly }: { form: DetailsForm; setForm: (form: DetailsForm) => void; taxonomy: CatalogTaxonomy; material: CatalogMaterial | null; setMaterial: (material: CatalogMaterial | null) => void; errors: Record<string, string>; readOnly: boolean }) {
  const [query, setQuery] = useState(material?.name ?? form.displayName)
  const { results, searching, error: lookupError, searchNow } = useMaterialSearch(query, !readOnly)
  const [searchError, setSearchError] = useState<string | null>(null)
  const other = form.materialId === null
  async function choose(match: CatalogMaterialMatch) {
    const chosen: DetailsForm = { ...form, materialId: match.id, materialMatch: match.matchType === 'FUZZY' ? 'FUZZY_CONFIRMED' : match.matchType, categoryId: match.categoryId, otherLabel: '' }
    setForm(chosen)
    try { const detail = await getMaterial(match.id); setMaterial(detail); if (form.tagIds.length === 0) setForm({ ...chosen, tagIds: detail.suggestedTagIds.slice(0, 3) }) }
    catch (cause) { setSearchError(await readableCatalogError(cause)) }
  }
  const shown = results ?? (material ? [{ id: material.id, code: material.code, name: material.name, categoryId: material.categoryId, categoryName: material.categoryName, regulated: material.regulated, matchType: 'EXACT' as const, matchedText: material.name, similarity: 1 }] : [])
  return <div className="grid gap-6">
    <section aria-labelledby="material-search-heading" className="grid gap-3">
      <SectionHeading id="material-search-heading" title="What material are you listing?">Type the name you use. MateryalPH matches it to a canonical material and flags DTI-BPS regulated products that need a PS Mark or ICC sticker.</SectionHeading>
      <div className="relative">
        <Field label="Material name" name="material_query" value={query} disabled={readOnly} autoComplete="off" onChange={event => setQuery(event.target.value)} onKeyDown={event => { if (event.key === 'Enter') { event.preventDefault(); searchNow() } }} hint="At least two characters. Matches update as you type." />
        <Search size={18} className="pointer-events-none absolute right-3 top-[2.6rem] text-text-secondary" aria-hidden="true" />
      </div>
      <p className="sr-only" role="status">{searching ? 'Searching materials…' : results ? `${results.length} matching materials` : ''}</p>
      {(searchError ?? lookupError) && <p className="text-sm text-status-error" role="alert">{searchError ?? lookupError}</p>}
      {errors.material && <p className="text-sm text-status-error" role="alert">{errors.material}</p>}
      <fieldset className="min-w-0 overflow-hidden rounded-surface border border-border-default" disabled={readOnly} aria-busy={searching}>
        <legend className="sr-only">Choose a material</legend>
        <ul className="divide-y divide-border-default">
          {shown.map(match => <MaterialMatchOption key={match.id} match={match} name="material_choice" selected={form.materialId === match.id} onChoose={() => void choose(match)} />)}
          {results !== null && results.length === 0 && <li className="px-4 py-3 text-sm text-text-secondary">No canonical material matches “{query.trim()}”. Describe the product with an Other label below.</li>}
          <li><label className={`flex min-h-14 cursor-pointer items-start gap-3 px-4 py-3 ${other ? 'bg-brand-orange-50' : 'hover:bg-surface-canvas'}`}>
            <input type="radio" name="material_choice" className="mt-0.5 h-5 w-5 shrink-0 accent-action-primary" checked={other} onChange={() => { setForm({ ...form, materialId: null, otherLabel: form.otherLabel || query.trim().slice(0, 60) }); setMaterial(null) }} />
            <span className="min-w-0"><span className="font-semibold">Not listed — use an Other label</span><span className="block text-sm text-text-secondary">The label describes this listing only. It never adds a shared material or category, and the listing stays Not Yet Comparable in Materials Analytics.</span></span>
          </label></li>
        </ul>
      </fieldset>
      {other && <div className="grid items-start gap-4 sm:grid-cols-2"><Field label="Other label" name="other_label" value={form.otherLabel} maxLength={60} disabled={readOnly} error={errors.other_label} hint="2–60 characters. Rental services are not supported." onChange={event => setForm({ ...form, otherLabel: event.target.value })} />
        <label className="grid min-w-0 gap-2 text-sm font-semibold">Category<select className={`${control} border-border-default`} value={form.categoryId} disabled={readOnly} onChange={event => setForm({ ...form, categoryId: event.target.value, technicalAttributes: {} })} aria-invalid={Boolean(errors.material_category_id)}><option value="">Choose a category</option>{taxonomy.categories.map(category => <option key={category.id} value={category.id}>{category.name}</option>)}</select>{errors.material_category_id && <span className="font-normal text-status-error" role="alert">{errors.material_category_id}</span>}</label></div>}
      {material?.regulatedRule && <p className="flex items-start gap-2 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900"><ShieldAlert size={18} className="mt-0.5 shrink-0" aria-hidden="true" /><span><strong>{material.regulatedRule.productName ?? material.name}</strong>{material.regulatedRule.referenceStandard ? ` (${material.regulatedRule.referenceStandard})` : ''} is DTI-BPS regulated. The listing publishes only after its PS Mark or ICC sticker is verified.</span></p>}
    </section>
    <fieldset className="grid min-w-0 gap-2" disabled={readOnly} aria-describedby="tag-hint">
      <legend className="w-full border-b border-border-default pb-2 text-xs font-semibold uppercase tracking-wide text-text-secondary">Search tags</legend>
      <p id="tag-hint" className="text-sm text-text-secondary">Choose one to three approved tags ({form.tagIds.length} of 3 selected).</p>
      {errors.tag_ids && <p className="text-sm text-status-error" role="alert">{errors.tag_ids}</p>}
      <div className="flex flex-wrap gap-2">{taxonomy.tags.map(tag => { const checked = form.tagIds.includes(tag.id); return <label key={tag.id} className={`inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-pill border px-4 text-sm font-semibold ${checked ? 'border-action-primary bg-brand-orange-50 text-action-primary' : 'border-border-default'}`}><input type="checkbox" className="h-4 w-4 accent-action-primary" checked={checked} disabled={!checked && form.tagIds.length >= 3} onChange={() => setForm({ ...form, tagIds: checked ? form.tagIds.filter(id => id !== tag.id) : [...form.tagIds, tag.id] })} />{tag.name}</label> })}</div>
    </fieldset>
  </div>
}

function AttributeField({ definition, value, onChange, error, readOnly }: { definition: CatalogAttributeDefinition; value: string; onChange: (value: string) => void; error?: string | undefined; readOnly: boolean }) {
  const label = `${definition.label}${definition.unitCode ? ` (${definition.unitCode})` : ''}`
  if (definition.valueType === 'ENUM' && definition.allowedValues) return <label className="grid min-w-0 gap-2 text-sm font-semibold">{label} {definition.required && <span className="sr-only">(required)</span>}<select className={`${control} border-border-default`} value={value} disabled={readOnly} aria-invalid={Boolean(error)} onChange={event => onChange(event.target.value)}><option value="">Choose</option>{definition.allowedValues.map(option => <option key={option} value={option}>{option}</option>)}</select>{error && <span className="font-normal text-status-error" role="alert">{error}</span>}</label>
  return <Field label={label} name={`attribute_${definition.code}`} value={value} disabled={readOnly} required={definition.required} inputMode={definition.valueType === 'NUMBER' ? 'decimal' : undefined} error={error} onChange={event => onChange(event.target.value)} />
}

export function ProductInformationStep({ listing, form, setForm, rows, setRows, taxonomy, material, errors, busy, readOnly }: { listing: CatalogListing; form: DetailsForm; setForm: (form: DetailsForm) => void; rows: VariantRow[]; setRows: (rows: VariantRow[]) => void; taxonomy: CatalogTaxonomy; material: CatalogMaterial | null; errors: Record<string, string>; busy: boolean; readOnly: boolean }) {
  const definitions = taxonomy.attributeDefinitions.filter(definition => definition.materialCategoryId === form.categoryId)
  const set = (key: keyof DetailsForm) => (event: { target: { value: string } }) => setForm({ ...form, [key]: event.target.value })
  const regulated = listing.regulated
  const nameSuggestion = (material?.name ?? form.otherLabel).trim()
  return <div className="grid gap-8">
    <section aria-labelledby="core-details-heading" className="grid gap-4">
      <SectionHeading id="core-details-heading" title="Core details" />
      <div className="grid gap-2">
        <Field label="Display name" name="display_name" value={form.displayName} required disabled={readOnly} error={errors.display_name} placeholder={nameSuggestion || undefined} hint={nameSuggestion && !form.displayName ? 'Empty — press Tab to use the suggestion from the material name.' : 'The name Buyers see in search results.'} onChange={set('displayName')}
          onKeyDown={event => { if (event.key === 'Tab' && !event.shiftKey && !form.displayName && nameSuggestion) { event.preventDefault(); setForm({ ...form, displayName: nameSuggestion }) } }} />
        {!readOnly && nameSuggestion && !form.displayName && <Button variant="quiet" className="w-fit" onClick={() => setForm({ ...form, displayName: nameSuggestion })}>Use suggestion: {nameSuggestion}</Button>}
      </div>
      <div className="grid items-start gap-4 sm:grid-cols-2">
        <Field label="Brand" name="brand" value={form.brand} required={regulated} disabled={readOnly} error={errors.brand} onChange={set('brand')} />
        <Field label="Manufacturer" name="manufacturer" value={form.manufacturer} required={regulated} disabled={readOnly} error={errors.manufacturer} onChange={set('manufacturer')} />
      </div>
      <Field label="Manufacturer address" name="manufacturer_address" value={form.manufacturerAddress} required={regulated} disabled={readOnly} error={errors.manufacturer_address} onChange={set('manufacturerAddress')} />
      <div className="grid items-start gap-4 sm:grid-cols-3">
        <Field label="Country of manufacture" name="country_of_manufacture" value={form.countryOfManufacture} maxLength={2} required={regulated} disabled={readOnly} error={errors.country_of_manufacture} hint="Two-letter code, for example PH." onChange={set('countryOfManufacture')} />
        <Field label="Model" name="model" value={form.model} disabled={readOnly} onChange={set('model')} />
        <Field label="Vendor SKU" name="vendor_sku" value={form.vendorSku} required disabled={readOnly} error={errors.vendor_sku} onChange={set('vendorSku')} />
      </div>
      <label className="grid gap-2 text-sm font-semibold" htmlFor="listing-description">Description <span className="sr-only">(required)</span><textarea id="listing-description" className="min-h-28 rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" value={form.description} disabled={readOnly} maxLength={4000} aria-invalid={Boolean(errors.description)} onChange={set('description')} />{errors.description && <span className="font-normal text-status-error" role="alert">{errors.description}</span>}</label>
      {regulated && <StatusMessage>Changing the material, brand, model, manufacturer, manufacturer address or country of a regulated product withdraws its verified PS/ICC status and requires a new submission.</StatusMessage>}
    </section>
    <section aria-labelledby="technical-heading" className="grid gap-4">
      <SectionHeading id="technical-heading" title="Technical details" />
      {definitions.length === 0 ? <p className="text-sm text-text-secondary">{form.categoryId ? 'This category has no structured technical fields.' : 'Choose a material or category first.'}</p>
        : <div className="grid items-start gap-4 sm:grid-cols-2">{definitions.map(definition => <AttributeField key={definition.id} definition={definition} value={form.technicalAttributes[definition.code] ?? ''} readOnly={readOnly} error={errors[`technical_attributes.${definition.code}`]} onChange={value => setForm({ ...form, technicalAttributes: { ...form.technicalAttributes, [definition.code]: value } })} />)}</div>}
    </section>
    <section aria-labelledby="pricing-heading" className="grid gap-4">
      <SectionHeading id="pricing-heading" title="Pricing and stock">Prices are the ordinary single-sale amount Buyers pay, VAT-inclusive. A changed price creates a new version; earlier versions stay attached to past publications and orders. Exact stock stays private — Buyers only see In Stock or Out of Stock.</SectionHeading>
      <VariantRows listing={listing} rows={rows} setRows={setRows} taxonomy={taxonomy} material={material} errors={errors} busy={busy} readOnly={readOnly} />
    </section>
  </div>
}

function VariantRows({ listing, rows, setRows, taxonomy, material, errors, busy, readOnly }: { listing: CatalogListing; rows: VariantRow[]; setRows: (rows: VariantRow[]) => void; taxonomy: CatalogTaxonomy; material: CatalogMaterial | null; errors: Record<string, string>; busy: boolean; readOnly: boolean }) {
  const units = material && material.compatibleUnitIds.length ? taxonomy.units.filter(unit => material.compatibleUnitIds.includes(unit.id)) : taxonomy.units
  const allowedTax = taxonomy.allowedTaxCategories
  const update = (index: number, patch: Partial<VariantRow>) => setRows(rows.map((row, position) => position === index ? { ...row, ...patch } : row))
  const rowError = (index: number, field: string) => errors[`variants.${index}.${field}`]
  const select = (invalid: boolean) => `${control} ${invalid ? 'border-status-error' : 'border-border-default'}`
  return <>
    {allowedTax.length === 0 && <StatusMessage tone="error">Your reviewed VAT classification is not available yet, so payable prices cannot be published. You can still save drafts.</StatusMessage>}
    {errors.variants && <StatusMessage tone="error">{errors.variants}</StatusMessage>}
    <RowGroup legend="Variants" rows={rows} maxRows={taxonomy.limits.maxVariants} disabled={readOnly || busy} addLabel="Add variant"
      rowLabel={(row, index) => `Variant ${index + 1}${row.label ? ` — ${row.label}` : ''}`}
      errorsFor={index => [...new Set(Object.entries(errors).filter(([key]) => key.startsWith(`variants.${index}.`)).map(([, message]) => message))]}
      onAdd={() => setRows([...rows, emptyVariant(listing.vendorSku, rows.length + 1)])} onRemove={index => setRows(rows.filter((_, position) => position !== index))}
      renderRow={(row, index) => {
        const unit = unitName(taxonomy, taxonomy.units.find(item => item.id === row.unitId)?.code)
        return <div className="grid gap-5">
          <div className="grid items-start gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <Field label="Variant SKU" name={`variants.${index}.sku`} value={row.sku} disabled={readOnly} error={rowError(index, 'sku')} onChange={event => update(index, { sku: event.target.value })} />
            <Field label="Label" name={`variants.${index}.label`} value={row.label} disabled={readOnly} hint="For example 40 kg or 10 mm × 6 m" onChange={event => update(index, { label: event.target.value })} />
            <label className="grid min-w-0 gap-2 text-sm font-semibold">Sale unit<select className={select(Boolean(rowError(index, 'unit_id')))} value={row.unitId} disabled={readOnly} aria-invalid={Boolean(rowError(index, 'unit_id'))} onChange={event => update(index, { unitId: event.target.value })}><option value="">Choose unit</option>{units.map(item => <option key={item.id} value={item.id}>{item.name} ({item.code})</option>)}</select></label>
            <Field label="Pack quantity" name={`variants.${index}.pack_quantity`} value={row.packQuantity} inputMode="decimal" disabled={readOnly} error={rowError(index, 'pack_quantity')} onChange={event => update(index, { packQuantity: event.target.value })} />
            <Field label="Price (PHP)" name={`variants.${index}.price`} value={row.price} inputMode="decimal" disabled={readOnly} error={rowError(index, 'price_centavos')} hint={`VAT-inclusive${row.priceVersion ? ` · version ${row.priceVersion}` : ''}${row.includedVat ? ` · includes ${formatCentavos(row.includedVat)} VAT` : ''}`} onChange={event => update(index, { price: event.target.value })} />
            <label className="grid min-w-0 gap-2 text-sm font-semibold">Tax classification<select className={select(Boolean(rowError(index, 'tax_category')))} value={row.taxCategory} disabled={readOnly} aria-invalid={Boolean(rowError(index, 'tax_category'))} onChange={event => update(index, { taxCategory: event.target.value })}><option value="">Choose</option>{(allowedTax.length ? allowedTax : taxonomy.taxCategories).map(category => <option key={category} value={category}>{TAX_LABELS[category] ?? statusLabel(category)}</option>)}</select></label>
            <Field label="Counted stock (private)" name={`variants.${index}.quantity_on_hand`} value={row.quantityOnHand} inputMode="decimal" disabled={readOnly} error={rowError(index, 'quantity_on_hand')} hint="Recording a count confirms stock today." onChange={event => update(index, { quantityOnHand: event.target.value })} />
            <div className="grid content-start gap-2 text-sm"><span className="font-semibold">Buyers see</span><span className="flex min-h-12 items-center">{row.publicAvailability === 'IN_STOCK' ? <span className="inline-flex items-center gap-1.5 font-semibold text-status-success"><CheckCircle2 size={16} aria-hidden="true" />In Stock</span> : row.id ? 'Out of Stock' : 'Shown after saving'}</span></div>
            {['VAT_ZERO', 'VAT_EXEMPT'].includes(row.taxCategory) && <div className="sm:col-span-2 xl:col-span-4"><Field label="Tax basis" name={`variants.${index}.tax_basis`} value={row.taxBasis} disabled={readOnly} error={rowError(index, 'tax_basis')} hint="Legal basis for zero-rating or exemption." onChange={event => update(index, { taxBasis: event.target.value })} /></div>}
          </div>
          <details className="rounded-control border border-border-default" open={Boolean(row.weightKg || row.lengthCm || row.widthCm || row.heightCm || rowError(index, 'weight_kg'))}>
            <summary className="min-h-11 cursor-pointer px-3 py-2.5 text-sm font-semibold">Weight and dimensions <span className="font-normal text-text-secondary">(used for delivery vehicle checks)</span></summary>
            <div className="grid items-start gap-4 border-t border-border-default p-3 sm:grid-cols-2 xl:grid-cols-4">
              <Field label="Weight (kg)" name={`variants.${index}.weight_kg`} value={row.weightKg} inputMode="decimal" disabled={readOnly} error={rowError(index, 'weight_kg')} onChange={event => update(index, { weightKg: event.target.value })} />
              <Field label="Length (cm)" name={`variants.${index}.length_cm`} value={row.lengthCm} inputMode="decimal" disabled={readOnly} error={rowError(index, 'length_cm')} onChange={event => update(index, { lengthCm: event.target.value })} />
              <Field label="Width (cm)" name={`variants.${index}.width_cm`} value={row.widthCm} inputMode="decimal" disabled={readOnly} error={rowError(index, 'width_cm')} onChange={event => update(index, { widthCm: event.target.value })} />
              <Field label="Height (cm)" name={`variants.${index}.height_cm`} value={row.heightCm} inputMode="decimal" disabled={readOnly} error={rowError(index, 'height_cm')} onChange={event => update(index, { heightCm: event.target.value })} />
            </div>
          </details>
          <VolumeTiers tiers={row.tiers} unit={unit} readOnly={readOnly} busy={busy} variantLabel={`Variant ${index + 1}`} error={(position, field) => rowError(index, `volume_tiers.${position}.${field}`)} onChange={tiers => update(index, { tiers })} />
        </div>
      }} />
  </>
}

function VolumeTiers({ tiers, unit, readOnly, busy, variantLabel, error, onChange }: { tiers: TierRow[]; unit: string; readOnly: boolean; busy: boolean; variantLabel: string; error: (position: number, field: string) => string | undefined; onChange: (tiers: TierRow[]) => void }) {
  const edit = (position: number, patch: Partial<TierRow>) => onChange(tiers.map((tier, index) => index === position ? { ...tier, ...patch } : tier))
  return <fieldset className="grid min-w-0 gap-3 rounded-control border border-border-default p-3">
    <legend className="px-1 text-sm font-semibold">Volume pricing <span className="font-normal text-text-secondary">(optional)</span></legend>
    <p className="text-sm text-text-secondary">Set lower unit prices for larger quantities on one order line. The highest tier a line reaches applies; below the first tier the ordinary price applies.</p>
    {tiers.length > 0 && <ol className="grid gap-3">{tiers.map((tier, position) => <li key={position} className="grid gap-3 rounded-control bg-surface-canvas p-3 sm:grid-cols-[minmax(0,1fr)_minmax(0,1fr)_minmax(0,1fr)_auto] sm:items-start">
      <Field label={`Minimum quantity${unit ? ` (${unit})` : ''}`} name={`tier-${variantLabel}-${position}-minimum`} value={tier.minimum} inputMode="decimal" disabled={readOnly} error={error(position, 'minimum_quantity')} onChange={event => edit(position, { minimum: event.target.value })} />
      <Field label="Price per unit (PHP)" name={`tier-${variantLabel}-${position}-price`} value={tier.price} inputMode="decimal" disabled={readOnly} error={error(position, 'price_centavos')} onChange={event => edit(position, { price: event.target.value })} />
      <div className="grid content-start gap-2 text-sm"><span className="font-semibold">Applies to</span><span className="flex min-h-12 items-center">{tierRange(tiers, position, unit)}</span></div>
      <Button variant="quiet" className="sm:mt-7" disabled={readOnly || busy} aria-label={`Remove volume tier ${position + 1} of ${variantLabel}`} onClick={() => onChange(tiers.filter((_, index) => index !== position))}><Trash2 size={16} aria-hidden="true" /> Remove</Button>
    </li>)}</ol>}
    {!readOnly && <Button variant="secondary" className="w-fit" disabled={busy || tiers.length >= MAX_TIERS} onClick={() => onChange([...tiers, { minimum: '', price: '' }])}>Add tier</Button>}
    {tiers.length >= MAX_TIERS && <p className="text-sm text-text-secondary">A variant can have up to {MAX_TIERS} volume tiers.</p>}
  </fieldset>
}

export function PhotosComplianceStep({ listing, taxonomy, busy, setBusy, readOnly, previews, onUpload, onRemove, mediaError, onComplianceSubmitted }: { listing: CatalogListing; taxonomy: CatalogTaxonomy; busy: boolean; setBusy: (busy: boolean) => void; readOnly: boolean; previews: Record<string, string>; onUpload: (file: File, replaces: string | null) => void; onRemove: (mediaId: string) => void; mediaError: string | null; onComplianceSubmitted: (listing: CatalogListing) => void }) {
  const items: MediaItem[] = listing.media.map(media => ({ id: media.id, label: media.altText ?? 'Product photo', status: media.status, version: media.version, scanState: media.scanState, contentType: media.contentType, byteSize: media.byteSize, previewUrl: media.status === 'READY' ? previews[media.fileId] ?? null : null }))
  return <div className="grid gap-8">
    <section aria-labelledby="photos-heading" className="grid gap-3">
      <SectionHeading id="photos-heading" title="Product photos">Product photos are public. Never upload business permits, IDs or PS/ICC evidence here — those stay private in their own sections.</SectionHeading>
      <MediaUploadField label="Product photos" accept={IMAGE_TYPES} acceptedLabel="JPG, PNG or WebP" maxBytes={taxonomy.limits.maxListingImageKb * 1024} maxItems={readOnly ? 0 : taxonomy.limits.maxMedia} items={items} busy={busy || readOnly} error={mediaError}
        onUpload={file => onUpload(file, null)} onReplace={(id, file) => onUpload(file, id)} onRemove={onRemove} />
    </section>
    <ComplianceSection listing={listing} canSubmit={listing.permissions.canSubmitCompliance} busy={busy} setBusy={setBusy} onSubmitted={onComplianceSubmitted} />
  </div>
}

type ReviewValues = { markingType: MarkingType; certificateNumber: string; manufacturerName: string; manufacturerAddress: string; importerName: string; importerAddress: string; countryOfManufacture: string; brand: string; batchNumber: string; confirmed: boolean }

async function decodeQr(file: File): Promise<string | null> {
  const Detector = (window as unknown as { BarcodeDetector?: new (options: { formats: string[] }) => { detect: (source: ImageBitmap) => Promise<{ rawValue: string }[]> } }).BarcodeDetector
  if (!Detector || typeof createImageBitmap !== 'function') return null
  try { const codes = await new Detector({ formats: ['qr_code'] }).detect(await createImageBitmap(file)); return codes[0]?.rawValue ?? null } catch { return null }
}

const pathOptions: { value: CompliancePath; label: string; description: string; icon: typeof Camera }[] = [
  { value: 'PHOTO_OCR', label: 'Photo or camera capture', description: 'Photograph the marking. Text reading, when available, only suggests values.', icon: Camera },
  { value: 'QR', label: 'QR code scan or upload', description: 'Upload an image of the QR code. Your browser reads it when supported.', icon: QrCode },
  { value: 'MANUAL', label: 'Manual entry', description: 'Type the details and attach a clear photo of the marking.', icon: ClipboardList },
]

function ComplianceSection({ listing, canSubmit, busy, setBusy, onSubmitted }: { listing: CatalogListing; canSubmit: boolean; busy: boolean; setBusy: (busy: boolean) => void; onSubmitted: (listing: CatalogListing) => void }) {
  const [path, setPath] = useState<CompliancePath>('PHOTO_OCR')
  const [evidence, setEvidence] = useState<ComplianceEvidence[]>([])
  const [error, setError] = useState<string | null>(null)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [values, setValues] = useState<ReviewValues>({ markingType: 'PS_MARK', certificateNumber: '', manufacturerName: listing.manufacturer ?? '', manufacturerAddress: listing.manufacturerAddress ?? '', importerName: '', importerAddress: '', countryOfManufacture: listing.countryOfManufacture ?? '', brand: listing.brand ?? '', batchNumber: '', confirmed: false })
  const reviewHeading = useRef<HTMLHeadingElement>(null)
  const picker = useRef<HTMLInputElement>(null)
  // A chosen photo is previewed locally and uploaded only after the Vendor confirms it.
  const [pending, setPending] = useState<{ file: File; url: string | null } | null>(null)
  const [thumbnails, setThumbnails] = useState<Record<string, string>>({})
  const objectUrls = useRef<string[]>([])
  useEffect(() => () => { objectUrls.current.forEach(url => URL.revokeObjectURL(url)) }, [])
  const rule = listing.regulatedRule
  if (!listing.regulated) return <section aria-labelledby="compliance-heading" className="grid gap-3"><SectionHeading id="compliance-heading" title="DTI-BPS compliance marking" /><StatusMessage>This material is not on the DTI-BPS list of regulated building and construction products, so no PS Mark or ICC sticker is requested.</StatusMessage></section>
  const latest = listing.complianceSubmissions[0]
  function choose(file: File | undefined) {
    if (!file) return
    setError(null)
    if (!IMAGE_TYPES.includes(file.type)) { setError(`${file.name} is not an accepted type. Use JPG, PNG or WebP.`); return }
    if (file.size > 10 * 1024 * 1024) { setError(`${file.name} is larger than 10 MB.`); return }
    const url = typeof URL.createObjectURL === 'function' ? URL.createObjectURL(file) : null
    if (url) objectUrls.current.push(url)
    setPending({ file, url })
  }
  async function upload() {
    if (!pending) return
    const { file, url } = pending
    setBusy(true); setError(null)
    try {
      const qrPayload = path === 'QR' ? await decodeQr(file) : null
      const stored = await uploadComplianceEvidence(listing.id, path, file, qrPayload)
      setEvidence(current => [...current, stored])
      if (url) setThumbnails(current => ({ ...current, [stored.evidenceId]: url }))
      setPending(null)
      const suggestions = stored.extraction.suggestions
      setValues(current => ({ ...current, ...(suggestions.marking_type === 'PS_MARK' || suggestions.marking_type === 'ICC_STICKER' ? { markingType: suggestions.marking_type } : {}), ...(suggestions.certificate_number ? { certificateNumber: suggestions.certificate_number } : {}), ...(suggestions.manufacturer_name ? { manufacturerName: suggestions.manufacturer_name } : {}), ...(suggestions.importer_name ? { importerName: suggestions.importer_name } : {}), confirmed: false }))
      window.requestAnimationFrame(() => reviewHeading.current?.focus())
    } catch (cause) { setError(await readableCatalogError(cause)) } finally { setBusy(false) }
  }
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setError(null); setErrors({})
    const local: Record<string, string> = {}
    if (values.certificateNumber.trim().length < 3) local.certificate_number = 'Enter the number exactly as printed on the marking.'
    if (values.markingType === 'PS_MARK' && !values.manufacturerName.trim()) local.manufacturer_name = 'Enter the manufacturer named on the PS licence.'
    if (values.markingType === 'ICC_STICKER' && !values.importerName.trim()) local.importer_name = 'Enter the importer named on the ICC certificate.'
    if (!values.confirmed) local.confirmed = 'Confirm that you reviewed each value against the physical marking.'
    if (Object.keys(local).length) { setErrors(local); return }
    setBusy(true)
    try {
      onSubmitted(await submitCompliance(listing.id, { listingLockVersion: listing.lockVersion, path, evidenceIds: evidence.map(item => item.evidenceId), markingType: values.markingType, certificateNumber: values.certificateNumber.trim(), manufacturerName: values.manufacturerName || null, manufacturerAddress: values.manufacturerAddress || null, importerName: values.importerName || null, importerAddress: values.importerAddress || null, countryOfManufacture: values.countryOfManufacture || null, brand: values.brand || null, batchNumber: values.batchNumber || null, confirmed: true }))
      setEvidence([])
    } catch (cause) { setErrors(await catalogFieldErrors(cause)); setError(await readableCatalogError(cause)) } finally { setBusy(false) }
  }
  const extraction = evidence.at(-1)?.extraction
  const set = (key: keyof ReviewValues) => (event: { target: { value: string } }) => setValues({ ...values, [key]: event.target.value })
  const markingName = values.markingType === 'PS_MARK' ? 'PS Mark' : 'ICC sticker'
  return <section aria-labelledby="compliance-heading" className="grid gap-5">
    <SectionHeading id="compliance-heading" title="DTI-BPS compliance marking (required)" />
    <div className="flex items-start gap-3 rounded-control border border-amber-300 bg-amber-50 p-4 text-sm text-amber-900"><ShieldAlert size={20} className="mt-0.5 shrink-0" aria-hidden="true" /><p><strong>{rule?.productName ?? 'This product'}</strong>{rule?.referenceStandard ? ` (${rule.referenceStandard})` : ''} is a DTI-BPS regulated product. The listing can be published only after its PS Mark (locally manufactured) or ICC sticker (imported) is verified. MateryalPH review is a marketplace control, not a DTI-BPS certification.</p></div>
    <dl className="grid gap-3 text-sm sm:grid-cols-3"><div><dt className="text-text-secondary">Reference standard</dt><dd className="font-semibold">{rule?.referenceStandard ?? '—'}</dd></div><div><dt className="text-text-secondary">Technical regulation</dt><dd className="font-semibold">{rule?.technicalRegulation ?? '—'}</dd></div><div><dt className="text-text-secondary">Scope</dt><dd>{rule?.scope ?? '—'}</dd></div></dl>
    {rule && rule.markingRequirements.length > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-2 font-semibold">Marking requirements ({rule.markingRequirements.length})</summary><ul className="mt-2 list-disc space-y-1 pl-5">{rule.markingRequirements.map(item => <li key={item}>{item}</li>)}</ul></details>}
    <div className="flex flex-wrap items-center gap-3"><ListingBadge status={listing.complianceStatus} prefix="PS/ICC" />{latest?.latestReview?.reason && <span className="text-sm text-text-secondary">Reviewer: {latest.latestReview.reason}</span>}</div>
    {listing.complianceStatus === 'VERIFIED' ? <StatusMessage tone="success">Verified{latest?.latestReview?.source === 'SYSTEM_REGISTER_MATCH' ? ' through an exact match with the current DTI-BPS register' : ' by Product Compliance review'}. Editing the manufacturer, brand, model or material reopens verification.</StatusMessage>
      : listing.complianceStatus === 'PENDING_ADMIN_REVIEW' ? <StatusMessage>Your submission is waiting for Product Compliance review. You can replace it with a corrected submission.</StatusMessage> : null}
    {!canSubmit ? <StatusMessage>Your role cannot submit PS/ICC evidence.</StatusMessage> : listing.complianceStatus !== 'VERIFIED' && <>
      <fieldset className="grid min-w-0 gap-2" disabled={busy}>
        <legend className="text-sm font-semibold">Marking on the product</legend>
        <div className="grid gap-3 sm:grid-cols-2">{(['PS_MARK', 'ICC_STICKER'] as const).map(type => { const checked = values.markingType === type; return <label key={type} className={`flex min-h-16 cursor-pointer items-start gap-3 rounded-control border p-3 ${checked ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}><input type="radio" name="marking_choice" className="mt-1 h-5 w-5 accent-action-primary" checked={checked} onChange={() => setValues({ ...values, markingType: type })} /><span><span className="block font-semibold">{type === 'PS_MARK' ? 'PS Mark' : 'ICC sticker'}</span><span className="block text-sm text-text-secondary">{type === 'PS_MARK' ? 'Locally manufactured · Philippine Standard' : 'Imported product · Import Commodity Clearance'}</span></span></label> })}</div>
      </fieldset>
      <fieldset className="grid min-w-0 gap-2" disabled={busy}>
        <legend className="text-sm font-semibold">How will you provide the marking?</legend>
        <div className="grid gap-3 md:grid-cols-3">{pathOptions.map(option => { const Icon = option.icon; const checked = path === option.value; return <label key={option.value} className={`flex min-h-11 cursor-pointer items-start gap-3 rounded-control border p-3 ${checked ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}><input type="radio" name="compliance_path" className="mt-1 h-5 w-5 shrink-0 accent-action-primary" checked={checked} onChange={() => { setPath(option.value); setEvidence([]) }} /><span className="min-w-0"><span className="flex items-center gap-1.5 font-semibold"><Icon size={16} aria-hidden="true" />{option.label}</span><span className="block text-sm text-text-secondary">{option.description}</span></span></label> })}</div>
      </fieldset>
      <label hidden={Boolean(pending)} className={`grid cursor-pointer justify-items-center gap-2 rounded-surface border-2 border-dashed p-6 text-center transition-colors motion-reduce:transition-none ${busy ? 'opacity-60' : 'border-brand-orange-300 bg-brand-orange-50 hover:border-action-primary'}`}>
        <UploadCloud size={28} className="text-action-primary" aria-hidden="true" />
        <span className="font-semibold">{path === 'QR' ? 'Upload QR code image' : `Upload ${markingName} marking photo`}</span>
        <span className="text-sm text-text-secondary">Take a clear, well-lit photo of the marking on the product or packaging. JPG, PNG or WebP up to 10 MB. You can check the photo before it is uploaded. Stored privately; never shown to Buyers.</span>
        <input ref={picker} type="file" accept={IMAGE_TYPES.join(',')} capture={path === 'PHOTO_OCR' ? 'environment' : undefined} disabled={busy} className="min-h-11 w-full min-w-0 max-w-xs text-sm" onChange={event => { choose(event.target.files?.[0]); event.target.value = '' }} />
      </label>
      {pending && <section aria-labelledby="pending-photo-heading" className="grid gap-4 rounded-surface border border-border-default p-4 sm:grid-cols-[minmax(0,18rem)_minmax(0,1fr)] sm:items-start">
        <div className="grid min-h-48 place-items-center overflow-hidden rounded-control border border-border-default bg-surface-canvas">{pending.url ? <img src={pending.url} alt={`Preview of ${pending.file.name}`} className="max-h-72 w-full object-contain" /> : <UploadCloud size={32} className="text-text-secondary" aria-hidden="true" />}</div>
        <div className="grid content-start gap-3">
          <h4 id="pending-photo-heading" className="text-lg font-semibold">Check the photo before uploading</h4>
          <p className="break-words text-sm text-text-secondary">{pending.file.name} · {Math.max(1, Math.round(pending.file.size / 1024))} KB</p>
          <p className="text-sm">Make sure the {path === 'QR' ? 'QR code' : `${markingName} and its licence or certificate number`} is sharp, fully in frame and readable. A blurry or cropped photo is returned for correction.</p>
          <div className="flex flex-wrap gap-2"><Button disabled={busy} onClick={() => void upload()}>{busy ? 'Uploading…' : 'Upload this photo'}</Button><Button variant="secondary" disabled={busy} onClick={() => picker.current?.click()}>Choose a different photo</Button><Button variant="quiet" disabled={busy} onClick={() => setPending(null)}>Cancel</Button></div>
        </div>
      </section>}
      {error && <StatusMessage tone="error">{error}</StatusMessage>}
      {evidence.length > 0 && <form className="grid gap-4 border-t border-border-default pt-5" onSubmit={submit} noValidate>
        <h4 ref={reviewHeading} tabIndex={-1} className="text-lg font-semibold">Review and confirm</h4>
        <ul className="grid gap-3 text-sm sm:grid-cols-2" aria-label="Uploaded marking photos">{evidence.map((item, index) => <li key={item.evidenceId} className="flex min-w-0 items-center gap-3 rounded-control border border-border-default p-2">
          <span className="grid h-20 w-20 shrink-0 place-items-center overflow-hidden rounded-control bg-surface-canvas">{thumbnails[item.evidenceId] ? <img src={thumbnails[item.evidenceId]} alt={`Uploaded ${item.evidenceKind === 'QR_IMAGE' ? 'QR image' : 'marking photo'} ${index + 1}`} className="h-full w-full object-cover" /> : <CheckCircle2 size={20} className="text-status-success" aria-hidden="true" />}</span>
          <span className="min-w-0 flex-1"><span className="block font-semibold">{item.evidenceKind === 'QR_IMAGE' ? 'QR image' : 'Marking photo'} {index + 1}</span><span className="flex items-center gap-1 text-text-secondary"><CheckCircle2 size={14} className="text-status-success" aria-hidden="true" />Safety check {item.scanState === 'CLEAN' ? 'passed' : item.scanState.toLowerCase()} · {Math.max(1, Math.round(item.byteSize / 1024))} KB</span></span>
          <Button variant="quiet" disabled={busy} aria-label={`Remove ${item.evidenceKind === 'QR_IMAGE' ? 'QR image' : 'marking photo'} ${index + 1}`} onClick={() => setEvidence(current => current.filter(entry => entry.evidenceId !== item.evidenceId))}><Trash2 size={16} aria-hidden="true" /></Button>
        </li>)}</ul>
        {!pending && <Button variant="secondary" className="w-fit" disabled={busy} onClick={() => picker.current?.click()}>Add another photo</Button>}
        <StatusMessage>{extraction?.status === 'EXTRACTED' ? `Suggested from the ${extraction.source === 'QR' ? 'QR code' : 'photo'}. Check every value against the physical marking and correct anything that differs.` : extraction?.status === 'NOT_REQUESTED' ? 'Enter the values exactly as printed on the marking.' : 'Automatic reading is not available for this image. Enter the values exactly as printed on the marking.'}</StatusMessage>
        <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Marking type</legend><div className="flex flex-wrap gap-3">{(['PS_MARK', 'ICC_STICKER'] as const).map(type => <label key={type} className="flex min-h-11 items-center gap-2 rounded-control border border-border-default px-3"><input type="radio" name="marking_type" className="h-5 w-5 accent-action-primary" checked={values.markingType === type} onChange={() => setValues({ ...values, markingType: type })} />{type === 'PS_MARK' ? 'PS Mark (locally manufactured)' : 'ICC sticker (imported)'}</label>)}</div></fieldset>
        <div className="grid items-start gap-4 sm:grid-cols-2">
          <Field label={values.markingType === 'PS_MARK' ? 'PS License No.' : 'ICC Certificate No.'} name="certificate_number" value={values.certificateNumber} required error={errors.certificate_number} hint="Enter it exactly as printed. It is checked against the DTI-BPS register after you submit." onChange={set('certificateNumber')} />
          <Field label="Brand" name="compliance_brand" value={values.brand} onChange={set('brand')} />
          <Field label="Manufacturer name" name="manufacturer_name" value={values.manufacturerName} required={values.markingType === 'PS_MARK'} error={errors.manufacturer_name} onChange={set('manufacturerName')} />
          <Field label="Manufacturer address" name="manufacturer_address_confirm" value={values.manufacturerAddress} onChange={set('manufacturerAddress')} />
          <Field label="Importer name" name="importer_name" value={values.importerName} required={values.markingType === 'ICC_STICKER'} error={errors.importer_name} onChange={set('importerName')} />
          <Field label="Importer address" name="importer_address" value={values.importerAddress} onChange={set('importerAddress')} />
          <Field label="Country of manufacture" name="compliance_country" value={values.countryOfManufacture} onChange={set('countryOfManufacture')} />
          <Field label="Batch or lot number" name="batch_number" value={values.batchNumber} onChange={set('batchNumber')} />
        </div>
        <label className="flex min-h-11 items-start gap-3 text-sm"><input type="checkbox" className="mt-1 h-5 w-5 accent-action-primary" checked={values.confirmed} aria-invalid={Boolean(errors.confirmed)} aria-describedby={errors.confirmed ? 'confirm-error' : undefined} onChange={event => setValues({ ...values, confirmed: event.target.checked })} />I checked every value against the physical marking on this product.</label>
        {errors.confirmed && <p id="confirm-error" className="text-sm text-status-error" role="alert">{errors.confirmed}</p>}
        <Button type="submit" className="w-fit" disabled={busy}>{busy ? 'Submitting…' : 'Submit PS/ICC evidence'}</Button>
      </form>}
    </>}
    {listing.complianceSubmissions.length > 0 && <section aria-labelledby="submission-history" className="grid gap-2 border-t border-border-default pt-5"><h4 id="submission-history" className="font-semibold">Submission history</h4><ul className="divide-y divide-border-default text-sm">{listing.complianceSubmissions.map(item => <li key={item.id} className="flex flex-wrap items-center gap-x-4 gap-y-1 py-2"><span className="font-semibold">Version {item.version}</span><ListingState status={item.status} /><span className="text-text-secondary">{statusLabel(item.path)}{item.latestReview ? ` · ${item.latestReview.source === 'SYSTEM_REGISTER_MATCH' ? 'Register match' : 'Admin review'}${item.latestReview.reason ? `: ${item.latestReview.reason}` : ''}` : ''}</span></li>)}</ul></section>}
  </section>
}

/** What still stands between this listing and Buyers, as the server reports it. */
export function PublicationGate({ listing, onGoTo }: { listing: CatalogListing; onGoTo: (step: number) => void }) {
  const groups = groupedBlockers(listing)
  const count = listing.blockers.length
  const waitingForCompliance = listing.regulated && listing.complianceStatus !== 'VERIFIED'
  return <section aria-labelledby="publication-gate-heading" className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4 text-sm">
    <h2 id="publication-gate-heading" className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Publication gate</h2>
    <div className="flex flex-wrap gap-2"><ListingBadge status={listing.status} />{listing.regulated && <ListingBadge status={listing.complianceStatus} prefix="PS/ICC" />}</div>
    {listing.status === 'ACTIVE' ? <p className="flex items-start gap-2 text-status-success"><CheckCircle2 size={16} className="mt-0.5 shrink-0" aria-hidden="true" />Published. Buyers can find it while it is in stock.</p>
      : count === 0 ? <p className="flex items-start gap-2">{waitingForCompliance ? <><ShieldAlert size={16} className="mt-0.5 shrink-0 text-status-warning" aria-hidden="true" />Complete. It becomes active once the PS/ICC evidence is verified.</> : <><Check size={16} className="mt-0.5 shrink-0 text-status-success" aria-hidden="true" />Every requirement is complete. You can publish.</>}</p>
        : <><p className="font-semibold">{count} {count === 1 ? 'item' : 'items'} before publishing</p><ul className="grid gap-2">{groups.map(group => <li key={group.label} className="grid gap-1"><button type="button" className="min-h-11 w-fit text-left font-semibold text-action-primary underline" onClick={() => onGoTo(group.index)}>{group.label}</button><ul className="grid gap-1 text-text-secondary">{group.blockers.map(blocker => <li key={blocker.key + blocker.reason} className="flex gap-2"><AlertCircle size={14} className="mt-0.5 shrink-0 text-status-error" aria-hidden="true" />{blocker.reason}</li>)}</ul></li>)}</ul></>}
  </section>
}

export function ReviewStep({ listing, taxonomy, previews, busy, readOnly, onGoTo, onPublish, onDeactivate }: { listing: CatalogListing; taxonomy: CatalogTaxonomy; previews: Record<string, string>; busy: boolean; readOnly: boolean; onGoTo: (step: number) => void; onPublish: () => void; onDeactivate: (reason: string | null) => void }) {
  const [reason, setReason] = useState('')
  const grouped = useMemo(() => groupedBlockers(listing), [listing])
  const published = listing.status === 'ACTIVE'
  const waitingForCompliance = listing.regulated && listing.complianceStatus !== 'VERIFIED'
  const requested = Boolean(listing.publicationRequestedAt) && !published
  const variants = listing.variants.filter(variant => variant.active && variant.price)
  const first = variants[0]
  const unit = unitName(taxonomy, first?.unitCode)
  const prices = variants.map(variant => variant.price?.amountCentavos ?? 0)
  const photo = listing.media.find(media => media.status === 'READY')
  const photoUrl = photo ? previews[photo.fileId] : undefined
  const tier = first?.volumeTiers?.[0]
  const category = taxonomy.categories.find(item => item.id === listing.materialCategoryId)?.name
  return <div className="grid gap-6">
    {published ? <StatusMessage tone="success">This listing is published. Buyers can find it while it is in stock.</StatusMessage>
      : grouped.length > 0 ? <StatusMessage tone="error">Complete the items below before publishing.</StatusMessage>
        : requested && waitingForCompliance ? <StatusMessage>Publication requested. The listing becomes active automatically once its PS/ICC evidence is verified; until then it stays hidden from Buyers.</StatusMessage>
        : waitingForCompliance ? <StatusMessage>Ready to request publication. The listing becomes active only after its PS/ICC evidence is verified; until then it stays hidden from Buyers.</StatusMessage>
          : <StatusMessage tone="success">Ready to publish. Publishing makes it active immediately; Buyers find it while it is in stock.</StatusMessage>}
    <section aria-labelledby="preview-heading" className="overflow-hidden rounded-surface border border-border-default">
      <div className="flex items-center justify-between gap-3 border-b border-border-default bg-surface-canvas px-4 py-2"><h3 id="preview-heading" className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Listing preview</h3>{!readOnly && <Button variant="quiet" onClick={() => onGoTo(1)}>Edit details</Button>}</div>
      <div className="grid gap-4 p-4 sm:grid-cols-[8rem_minmax(0,1fr)]">
        <div className="grid aspect-square w-32 place-items-center overflow-hidden rounded-control bg-surface-canvas">{photoUrl ? <img src={photoUrl} alt="" className="h-full w-full object-cover" /> : <Package size={36} className="text-text-secondary" aria-hidden="true" />}</div>
        <div className="grid min-w-0 content-start gap-2">
          <p className="break-words text-lg font-semibold">{listing.displayName}</p>
          <p className="text-sm text-text-secondary">{[listing.brand, listing.manufacturer].filter(Boolean).join(' · ') || 'Brand and manufacturer not entered'}</p>
          <div className="flex flex-wrap gap-2">{listing.regulated && <ListingBadge status={listing.complianceStatus} prefix="PS/ICC" />}{(category ?? listing.material?.name) && <span className="inline-flex min-h-8 items-center rounded-pill border border-border-default px-3 text-xs font-semibold">{category ?? listing.material?.name}</span>}</div>
          <p><span className="text-xl font-semibold">{prices.length === 0 ? 'No price yet' : Math.min(...prices) === Math.max(...prices) ? formatCentavos(prices[0]) : `${formatCentavos(Math.min(...prices))} – ${formatCentavos(Math.max(...prices))}`}</span>{unit && prices.length > 0 && <span className="text-sm text-text-secondary"> / {unit}</span>}</p>
          {tier && <p className="text-sm text-text-secondary">Volume price: {formatCentavos(tier.amountCentavos)} / {unit || 'unit'} from {quantityText(tier.minimumQuantity)} {unit}</p>}
        </div>
      </div>
      <dl className="grid gap-3 border-t border-border-default p-4 text-sm sm:grid-cols-2 lg:grid-cols-3">
        <div><dt className="text-text-secondary">Manufacturer</dt><dd className="font-semibold">{listing.manufacturer ?? '—'}</dd></div>
        <div><dt className="text-text-secondary">Country of manufacture</dt><dd className="font-semibold">{listing.countryOfManufacture ?? '—'}</dd></div>
        <div><dt className="text-text-secondary">Vendor SKU</dt><dd className="font-semibold">{listing.vendorSku}</dd></div>
        <div><dt className="text-text-secondary">Variants</dt><dd className="font-semibold">{listing.variants.filter(variant => variant.active).length}</dd></div>
        <div><dt className="text-text-secondary">Buyers see</dt><dd className="font-semibold">{listing.variants.some(variant => variant.active && variant.publicAvailability === 'IN_STOCK') ? 'In Stock' : 'Out of Stock'}</dd></div>
        <div><dt className="text-text-secondary">Publication version</dt><dd className="font-semibold">{listing.publicationVersion}</dd></div>
      </dl>
    </section>
    {grouped.length > 0 && <section aria-labelledby="blockers-heading" className="grid gap-3"><h3 id="blockers-heading" className="text-lg font-semibold">Before publishing</h3>{grouped.map(group => <div key={group.label} className="rounded-control border border-border-default p-3"><div className="flex flex-wrap items-center justify-between gap-2"><p className="font-semibold">{group.label}</p><Button variant="quiet" onClick={() => onGoTo(group.index)}>Go to step {group.index + 1}</Button></div><ul className="mt-2 grid gap-1 text-sm">{group.blockers.map(blocker => <li key={blocker.key + blocker.reason} className="flex gap-2"><AlertCircle size={16} className="mt-0.5 shrink-0 text-status-error" aria-hidden="true" />{blocker.reason}</li>)}</ul></div>)}</section>}
    {!readOnly && !published && !requested && <div className="flex flex-wrap gap-3"><Button disabled={busy || grouped.length > 0} onClick={onPublish}>{busy ? 'Publishing…' : waitingForCompliance ? 'Request publication' : 'Publish listing'}</Button></div>}
    {!readOnly && ['ACTIVE', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED'].includes(listing.status) && <section aria-labelledby="deactivate-heading" className="grid gap-3 border-t border-border-default pt-5">
      <div><h3 id="deactivate-heading" className="font-semibold">Deactivate listing</h3><p className="text-sm text-text-secondary">Stops offering it to Buyers. Its history and past orders are kept, and you can publish it again later.</p></div>
      <div className="grid items-end gap-3 sm:grid-cols-[minmax(0,20rem)_auto]"><Field label="Reason (optional)" name="deactivate_reason" value={reason} onChange={event => setReason(event.target.value)} /><Button variant="secondary" className="w-fit" disabled={busy} onClick={() => onDeactivate(reason.trim() || null)}>Deactivate listing</Button></div>
    </section>}
    {listing.statusHistory.length > 0 && <section aria-labelledby="history-heading" className="grid gap-2 border-t border-border-default pt-5"><h3 id="history-heading" className="text-lg font-semibold">Status history</h3><ol className="divide-y divide-border-default text-sm">{listing.statusHistory.map((entry, index) => <li key={index} className="py-2">{entry.fromStatus ? `${statusLabel(entry.fromStatus)} → ` : ''}{statusLabel(entry.toStatus)} · {statusLabel(entry.source)}{entry.reasonCode ? ` · ${statusLabel(entry.reasonCode)}` : ''}{entry.createdAt ? ` · ${new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(new Date(entry.createdAt))}` : ''}</li>)}</ol></section>}
  </div>
}
