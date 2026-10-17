import { useEffect, useMemo, useRef, useState, type FormEvent } from 'react'
import { AlertCircle, Camera, Check, CheckCircle2, ClipboardCheck, ClipboardList, Package, Pencil, QrCode, RefreshCw, Search, ShieldAlert, Trash2, Truck, UploadCloud } from 'lucide-react'
import type { CatalogAttributeDefinition, CompliancePath, MarkingType } from '@materyalph/api-client-ts'
import { Button, Field, MediaUploadField, RowGroup, StatusMessage, type MediaItem } from '@materyalph/web-ui'
import {
  formatCentavos, getMaterial, readableCatalogError, catalogFieldErrors, lookupCompliance, refusedComplianceLookup, submitCompliance, uploadComplianceEvidence,
  type CatalogListing, type CatalogMaterial, type CatalogMaterialMatch, type CatalogTaxonomy, type ComplianceEvidence, type ComplianceLookup,
} from '../lib/catalog-api'
import { decodeQrFromImage } from '../lib/qr-decode'
import { IMAGE_TYPES, MAX_TIERS, emptyVariant, groupedBlockers, quantityText, tierRange, unitName, useMaterialSearch, type DetailsForm, type TierRow, type VariantRow } from '../lib/catalog-form'
import { measuringTip, suggestMeasurements, suggestedVariantLabel, technicalWarnings } from '../lib/listing-measurements'
import { statusLabel } from '../lib/vendor-status'
import { ATTRIBUTE_DESCRIPTIONS, duplicateStrengths, isReadyMixed, STRENGTH_ATTRIBUTE, strengthLabel } from '../lib/ready-mixed-concrete'
import { listFleet, type FleetVehicle } from '../lib/inventory-api'
import { AdvisoryText, CategorySection, CustomTagField, MeasurementFields, MixerVolumeSuggestion, ReadyMixedWeightField } from './CatalogMeasurementParts'
import { ListingBadge, ListingState } from './CatalogShared'

const TAX_LABELS: Record<string, string> = { VAT_12: 'VAT 12%', VAT_ZERO: 'Zero-rated', VAT_EXEMPT: 'VAT-exempt', NON_VAT: 'Non-VAT' }
const control = 'min-h-12 w-full min-w-0 rounded-control border bg-surface-primary px-3 text-base font-normal'

function SectionHeading({ id, title, children }: { id: string; title: string; children?: string | undefined }) {
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
      <p id="tag-hint" className="text-sm text-text-secondary">Choose up to three approved tags ({form.tagIds.length} of 3 selected) and add your own. At least one tag is needed.</p>
      {errors.tag_ids && <p className="text-sm text-status-error" role="alert">{errors.tag_ids}</p>}
      <div className="flex flex-wrap gap-2">{taxonomy.tags.map(tag => { const checked = form.tagIds.includes(tag.id); return <label key={tag.id} className={`inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-pill border px-4 text-sm font-semibold ${checked ? 'border-action-primary bg-brand-orange-50 text-action-primary' : 'border-border-default'}`}><input type="checkbox" className="h-4 w-4 accent-action-primary" checked={checked} disabled={!checked && form.tagIds.length >= 3} onChange={() => setForm({ ...form, tagIds: checked ? form.tagIds.filter(id => id !== tag.id) : [...form.tagIds, tag.id] })} />{tag.name}</label> })}</div>
      <CustomTagField tags={form.customTags} readOnly={readOnly} error={errors.custom_tags} onChange={customTags => setForm({ ...form, customTags })} />
    </fieldset>
  </div>
}

function AttributeField({ definition, value, onChange, error, warning, readOnly }: { definition: CatalogAttributeDefinition; value: string; onChange: (value: string) => void; error?: string | undefined; warning?: string | undefined; readOnly: boolean }) {
  const label = `${definition.label}${definition.unitCode ? ` (${definition.unitCode})` : ''}`
  if (definition.valueType === 'ENUM' && definition.allowedValues) return <label className="grid min-w-0 gap-2 text-sm font-semibold">{label} {definition.required && <span className="sr-only">(required)</span>}<select className={`${control} border-border-default`} value={value} disabled={readOnly} aria-invalid={Boolean(error)} onChange={event => onChange(event.target.value)}><option value="">Choose</option>{definition.allowedValues.map(option => <option key={option} value={option}>{option}</option>)}</select>{error && <span className="font-normal text-status-error" role="alert">{error}</span>}</label>
  return <Field label={label} name={`attribute_${definition.code}`} value={value} disabled={readOnly} required={definition.required} inputMode={definition.valueType === 'NUMBER' ? 'decimal' : undefined} error={error} hint={warning ? <AdvisoryText>{warning}</AdvisoryText> : ATTRIBUTE_DESCRIPTIONS[definition.code]} onChange={event => onChange(event.target.value)} />
}

/** Material and category codes the measurement suggestions key on; a material changed but not yet loaded has none. */
function measurementCodes(listing: CatalogListing, form: DetailsForm, taxonomy: CatalogTaxonomy, material: CatalogMaterial | null) {
  const materialCode = form.materialId === null ? null : material?.id === form.materialId ? material.code : listing.material?.id === form.materialId ? listing.material.code : null
  return { materialCode, categoryCode: taxonomy.categories.find(category => category.id === form.categoryId)?.code ?? null }
}

export function ProductInformationStep({ listing, form, setForm, rows, setRows, taxonomy, material, errors, busy, readOnly, onEditMaterial }: { listing: CatalogListing; form: DetailsForm; setForm: (form: DetailsForm) => void; rows: VariantRow[]; setRows: (rows: VariantRow[]) => void; taxonomy: CatalogTaxonomy; material: CatalogMaterial | null; errors: Record<string, string>; busy: boolean; readOnly: boolean; onEditMaterial?: () => void }) {
  const definitions = taxonomy.attributeDefinitions.filter(definition => definition.materialCategoryId === form.categoryId)
  const set = (key: keyof DetailsForm) => (event: { target: { value: string } }) => setForm({ ...form, [key]: event.target.value })
  const regulated = listing.regulated
  const nameSuggestion = (material?.name ?? form.otherLabel).trim()
  const { materialCode, categoryCode } = measurementCodes(listing, form, taxonomy, material)
  const attributeWarnings = technicalWarnings(categoryCode, form.technicalAttributes, definitions)
  const readyMixed = isReadyMixed(materialCode, categoryCode)
  // Ready-mixed concrete sets its Required PSI on each variant, so each strength class carries its own price.
  const listingDefinitions = readyMixed ? definitions.filter(definition => definition.code !== STRENGTH_ATTRIBUTE) : definitions
  return <div className="grid gap-8">
    <CategorySection form={form} setForm={setForm} taxonomy={taxonomy} material={material} readOnly={readOnly} error={errors.material_category_id} onEditMaterial={onEditMaterial} />
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
    {readyMixed && <StatusMessage>
      <span className="flex items-start gap-2"><Truck size={18} className="mt-0.5 shrink-0" aria-hidden="true" /><span><strong>Ready-mixed concrete.</strong> Delivered only by your Concrete Mixer Truck / Transit Mixer through Site Delivery; Buyers cannot choose Self-Pickup. Add one variant per Required PSI, each with its own price per cubic meter. Trucks and trips follow the ordered volume and your Mixer Capacity (m³).</span></span>
    </StatusMessage>}
    <section aria-labelledby="technical-heading" className="grid gap-4">
      <SectionHeading id="technical-heading" title="Technical details">{readyMixed ? 'Describe the mix. The Required PSI is set on each variant below.' : definitions.length ? 'Describe one product. Weight and dimensions under each variant are checked against these values.' : undefined}</SectionHeading>
      {listingDefinitions.length === 0 ? <p className="text-sm text-text-secondary">{form.categoryId ? 'This category has no structured technical fields.' : 'Choose a material or category first.'}</p>
        : <div className="grid items-start gap-4 sm:grid-cols-2">{listingDefinitions.map(definition => <AttributeField key={definition.id} definition={definition} value={form.technicalAttributes[definition.code] ?? ''} readOnly={readOnly} error={errors[`technical_attributes.${definition.code}`]} warning={attributeWarnings[definition.code]} onChange={value => setForm({ ...form, technicalAttributes: { ...form.technicalAttributes, [definition.code]: value } })} />)}</div>}
    </section>
    <section aria-labelledby="pricing-heading" className="grid gap-4">
      <SectionHeading id="pricing-heading" title="Pricing and stock">Prices are the ordinary single-sale amount Buyers pay, VAT-inclusive. A changed price creates a new version; earlier versions stay attached to past publications and orders. Exact stock stays private — Buyers only see In Stock or Out of Stock.</SectionHeading>
      <VariantRows listing={listing} form={form} rows={rows} setRows={setRows} taxonomy={taxonomy} material={material} errors={errors} busy={busy} readOnly={readOnly} />
    </section>
  </div>
}

function VariantRows({ listing, form, rows, setRows, taxonomy, material, errors, busy, readOnly }: { listing: CatalogListing; form: DetailsForm; rows: VariantRow[]; setRows: (rows: VariantRow[]) => void; taxonomy: CatalogTaxonomy; material: CatalogMaterial | null; errors: Record<string, string>; busy: boolean; readOnly: boolean }) {
  const units = material && material.compatibleUnitIds.length ? taxonomy.units.filter(unit => material.compatibleUnitIds.includes(unit.id)) : taxonomy.units
  const allowedTax = taxonomy.allowedTaxCategories
  const { materialCode, categoryCode } = measurementCodes(listing, form, taxonomy, material)
  const listingLabelSuggestion = suggestedVariantLabel(categoryCode, form.technicalAttributes)
  const guideTip = measuringTip(materialCode, categoryCode)
  const readyMixed = isReadyMixed(materialCode, categoryCode)
  const strength = readyMixed ? taxonomy.attributeDefinitions.find(definition => definition.materialCategoryId === form.categoryId && definition.code === STRENGTH_ATTRIBUTE) : undefined
  const repeated = readyMixed ? duplicateStrengths(rows) : new Set<number>()
  const update = (index: number, patch: Partial<VariantRow>) => setRows(rows.map((row, position) => position === index ? { ...row, ...patch } : row))
  // Ready-mixed concrete is always sold per cubic meter, one batch at a time, and the strength class names the variant.
  const cubicMeterId = taxonomy.units.find(item => item.code === 'CUM')?.id ?? ''
  const fixedFor = (row: VariantRow): Partial<VariantRow> => {
    const patch: Partial<VariantRow> = {}
    const label = strengthLabel(row.attributes[STRENGTH_ATTRIBUTE])
    if (cubicMeterId && row.unitId !== cubicMeterId) patch.unitId = cubicMeterId
    if (row.packQuantity !== '1') patch.packQuantity = '1'
    if (label && row.label !== label) patch.label = label
    return patch
  }
  useEffect(() => {
    if (!readyMixed || readOnly || !rows.some(row => Object.keys(fixedFor(row)).length)) return
    setRows(rows.map(row => ({ ...row, ...fixedFor(row) })))
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [readyMixed, readOnly, rows, cubicMeterId])
  // The Vendor's listed mixer trucks drive the batch-volume suggestion; a failed read just hides the suggestion.
  const [fleet, setFleet] = useState<FleetVehicle[] | null>(null)
  useEffect(() => {
    if (!readyMixed) return
    let active = true
    listFleet().then(result => { if (active) setFleet(result.items) }).catch(() => undefined)
    return () => { active = false }
  }, [readyMixed])
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
        const unitCode = taxonomy.units.find(item => item.id === row.unitId)?.code ?? null
        const unit = unitName(taxonomy, unitCode)
        const suggestion = suggestMeasurements({ materialCode, categoryCode, unitCode, packQuantity: row.packQuantity, attributes: form.technicalAttributes })
        const labelSuggestion = readyMixed ? strengthLabel(row.attributes[STRENGTH_ATTRIBUTE]) : listingLabelSuggestion
        return <div className="grid gap-5">
          {strength && <div className="grid max-w-md gap-1">
            <AttributeField definition={strength} value={row.attributes[STRENGTH_ATTRIBUTE] ?? ''} readOnly={readOnly} error={rowError(index, `attributes.${STRENGTH_ATTRIBUTE}`) ?? errors[`technical_attributes.${STRENGTH_ATTRIBUTE}`]}
              onChange={value => update(index, { attributes: { ...row.attributes, [STRENGTH_ATTRIBUTE]: value } })} />
            {repeated.has(index) && <AdvisoryText>Another variant already offers this PSI. Keep one variant per strength class.</AdvisoryText>}
          </div>}
          <div className="grid items-start gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <Field label="Variant SKU" name={`variants.${index}.sku`} value={row.sku} disabled={readOnly} error={rowError(index, 'sku')} onChange={event => update(index, { sku: event.target.value })} />
            {readyMixed
              ? <div className="grid content-start gap-2 text-sm"><span className="font-semibold">Sold per</span><span className="flex min-h-12 items-center">Cubic meter (m³)</span></div>
              : <>
                <div className="grid min-w-0 gap-1">
                  <Field label="Label" name={`variants.${index}.label`} value={row.label} disabled={readOnly} hint={`For example ${labelSuggestion ?? '40 kg or 10 mm × 6 m'}`} onChange={event => update(index, { label: event.target.value })} />
                  {!readOnly && labelSuggestion && !row.label.trim() && <Button variant="quiet" className="w-fit text-action-primary" onClick={() => update(index, { label: labelSuggestion })}>Use “{labelSuggestion}”</Button>}
                </div>
                <label className="grid min-w-0 gap-2 text-sm font-semibold">Sale unit<select className={select(Boolean(rowError(index, 'unit_id')))} value={row.unitId} disabled={readOnly} aria-invalid={Boolean(rowError(index, 'unit_id'))} onChange={event => update(index, { unitId: event.target.value })}><option value="">Choose unit</option>{units.map(item => <option key={item.id} value={item.id}>{item.name} ({item.code})</option>)}</select></label>
                <Field label="Pack quantity" name={`variants.${index}.pack_quantity`} value={row.packQuantity} inputMode="decimal" disabled={readOnly} error={rowError(index, 'pack_quantity')} onChange={event => update(index, { packQuantity: event.target.value })} />
              </>}
            <Field label="Price (PHP)" name={`variants.${index}.price`} value={row.price} inputMode="decimal" disabled={readOnly} error={rowError(index, 'price_centavos')} hint={`VAT-inclusive${row.priceVersion ? ` · version ${row.priceVersion}` : ''}${row.includedVat ? ` · includes ${formatCentavos(row.includedVat)} VAT` : ''}`} onChange={event => update(index, { price: event.target.value })} />
            <label className="grid min-w-0 gap-2 text-sm font-semibold">Tax classification<select className={select(Boolean(rowError(index, 'tax_category')))} value={row.taxCategory} disabled={readOnly} aria-invalid={Boolean(rowError(index, 'tax_category'))} onChange={event => update(index, { taxCategory: event.target.value })}><option value="">Choose</option>{(allowedTax.length ? allowedTax : taxonomy.taxCategories).map(category => <option key={category} value={category}>{TAX_LABELS[category] ?? statusLabel(category)}</option>)}</select></label>
            <div className="grid min-w-0 content-start gap-3">
              <Field label={readyMixed ? 'Volume you can batch (m³, private)' : 'Counted stock (private)'} name={`variants.${index}.quantity_on_hand`} value={row.quantityOnHand} inputMode="decimal" disabled={readOnly} error={rowError(index, 'quantity_on_hand')} hint={readyMixed ? 'Cubic meters you can supply now. Recording it confirms stock today.' : 'Recording a count confirms stock today.'} onChange={event => update(index, { quantityOnHand: event.target.value })} />
              {readyMixed && <MixerVolumeSuggestion fleet={fleet} row={row} readOnly={readOnly} onUse={quantityOnHand => update(index, { quantityOnHand })} />}
            </div>
            <div className="grid content-start gap-2 text-sm"><span className="font-semibold">Buyers see</span><span className="flex min-h-12 items-center">{row.publicAvailability === 'IN_STOCK' ? <span className="inline-flex items-center gap-1.5 font-semibold text-status-success"><CheckCircle2 size={16} aria-hidden="true" />In Stock</span> : row.id ? 'Out of Stock' : 'Shown after saving'}</span></div>
            {['VAT_ZERO', 'VAT_EXEMPT'].includes(row.taxCategory) && <div className="sm:col-span-2 xl:col-span-4"><Field label="Tax basis" name={`variants.${index}.tax_basis`} value={row.taxBasis} disabled={readOnly} error={rowError(index, 'tax_basis')} hint="Legal basis for zero-rating or exemption." onChange={event => update(index, { taxBasis: event.target.value })} /></div>}
          </div>
          {readyMixed
            ? <ReadyMixedWeightField row={row} index={index} readOnly={readOnly} error={rowError(index, 'weight_kg')} onChange={patch => update(index, patch)} />
            : <MeasurementFields row={row} index={index} unit={unit} suggestion={suggestion} guideTip={guideTip} readOnly={readOnly} rowError={field => rowError(index, field)} onChange={patch => update(index, patch)} />}
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

type LookupState = { status: 'idle' } | { status: 'checking'; number: string } | { status: 'done'; number: string; lookup: ComplianceLookup } | { status: 'failed'; number: string; message: string }

const MARKING_COPY = {
  PS_MARK: { name: 'PS Mark', numberLabel: 'PS License No.', example: 'Q-1234', where: 'Printed below the PS Mark after “License No.”, for example Q-1234.', company: 'Manufacturer (PS licensee)', list: 'List of PS Licensees' },
  ICC_STICKER: { name: 'ICC sticker', numberLabel: 'ICC sticker serial no.', example: 'A500000001', where: 'Printed below the QR code on the sticker: one letter and the digits, for example A500000001.', company: 'Importer (ICC certificate holder)', list: 'List of ICC Certificate Holders' },
} as const

const LOOKUP_TITLES: Record<string, string> = {
  NUMBER_NOT_FOUND: 'Not found in the DTI-BPS register', NUMBER_FORMAT: 'Check the number format', CERTIFICATE_NUMBER_GIVEN: 'Enter the sticker serial instead',
  PRODUCT_NOT_COVERED: 'Listed for a different product', RECORD_EXPIRED: 'The listed record has expired', NO_ACTIVE_REGISTER: 'The register is not available yet',
}

/** A typed number complete enough to check while the Vendor is still typing. */
function looksComplete(markingType: MarkingType, value: string): boolean {
  const compact = value.toUpperCase().replace(/[^A-Z0-9]/g, '')
  return markingType === 'PS_MARK' ? /^Q\d{3,5}$/.test(compact) : /^[A-Z]{1,2}\d{7,10}$/.test(compact)
}

function extractionNote(stored: ComplianceEvidence, numberLabel: string, qrRead: boolean): string {
  const number = stored.extraction.suggestions.certificate_number
  if (number) {
    const from = stored.extraction.source === 'QR' ? 'the QR code' : 'the photo'
    return `Read ${number} from ${from}${stored.extraction.registerListed ? ', and it is listed in the DTI-BPS register' : ''}. Check it against the marking.`
  }
  if (stored.path === 'QR' && !qrRead) return `No QR code could be read from this image. Try a sharper, straight-on photo, or type the ${numberLabel} below.`
  if (stored.path === 'MANUAL') return `Photo attached. Type the ${numberLabel} exactly as printed.`
  return `The ${numberLabel} could not be read from this photo. Type it exactly as printed, or upload a sharper photo.`
}

const pathOptions: { value: CompliancePath; label: string; description: string; icon: typeof Camera }[] = [
  { value: 'PHOTO_OCR', label: 'Photo or camera capture', description: 'Photograph the marking. The number is read from the photo or the sticker’s QR code and checked automatically.', icon: Camera },
  { value: 'QR', label: 'QR code scan or upload', description: 'Upload or photograph the ICC sticker’s QR code. It is read in your browser.', icon: QrCode },
  { value: 'MANUAL', label: 'Manual entry', description: 'Type the number and attach a clear photo of the marking.', icon: ClipboardList },
]

function RegisterRecord({ lookup }: { lookup: ComplianceLookup }) {
  const record = lookup.record
  if (!record) return null
  const copy = MARKING_COPY[lookup.markingType]
  const rows: [string, string | null | undefined][] = [
    [copy.company, record.companyName], ['Product', record.productDescription], ['Brand', record.brand], ['Model or type', record.modelType],
    ['Product standard', record.referenceStandard], ['PS License No.', record.licenseNumber], ['ICC certificate no.', record.iccCertificateNumber],
    ['Sticker serial range', record.serialRange], ['Local or foreign', record.origin], ['Valid until', record.expiresOn],
  ]
  return <dl className="grid gap-x-6 gap-y-2 text-sm sm:grid-cols-2">{rows.filter(([, value]) => value).map(([label, value]) => <div key={label} className="min-w-0"><dt className="text-text-secondary">{label}</dt><dd className="whitespace-pre-line break-words font-semibold">{value}</dd></div>)}</dl>
}

function ComplianceSection({ listing, canSubmit, busy, setBusy, onSubmitted }: { listing: CatalogListing; canSubmit: boolean; busy: boolean; setBusy: (busy: boolean) => void; onSubmitted: (listing: CatalogListing) => void }) {
  const [path, setPath] = useState<CompliancePath>('PHOTO_OCR')
  const [markingType, setMarkingType] = useState<MarkingType>('PS_MARK')
  const [evidence, setEvidence] = useState<ComplianceEvidence[]>([])
  const [number, setNumber] = useState('')
  const [batchNumber, setBatchNumber] = useState('')
  const [reviewNote, setReviewNote] = useState('')
  const [confirmed, setConfirmed] = useState(false)
  const [manualReview, setManualReview] = useState(false)
  const [lookup, setLookup] = useState<LookupState>({ status: 'idle' })
  const [readNote, setReadNote] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const numberInput = useRef<HTMLInputElement>(null)
  const picker = useRef<HTMLInputElement>(null)
  const lookupRequest = useRef(0)
  // A chosen photo is previewed locally and uploaded only after the Vendor confirms it.
  const [pending, setPending] = useState<{ file: File; url: string | null } | null>(null)
  const [thumbnails, setThumbnails] = useState<Record<string, string>>({})
  const objectUrls = useRef<string[]>([])
  useEffect(() => () => { objectUrls.current.forEach(url => URL.revokeObjectURL(url)) }, [])
  const copy = MARKING_COPY[markingType]
  const checkedNumber = lookup.status === 'idle' ? null : lookup.number

  async function check(value: string) {
    const trimmed = value.trim()
    if (trimmed.length < 3) { setErrors({ certificate_number: `Enter the ${copy.numberLabel} as printed, for example ${copy.example}.` }); return }
    const request = ++lookupRequest.current
    setErrors({}); setConfirmed(false); setManualReview(false)
    setLookup({ status: 'checking', number: trimmed })
    try {
      const result = await lookupCompliance(listing.id, markingType, trimmed)
      if (request === lookupRequest.current) setLookup({ status: 'done', number: trimmed, lookup: result })
    } catch (cause) {
      const message = await readableCatalogError(cause)
      if (request === lookupRequest.current) setLookup({ status: 'failed', number: trimmed, message })
    }
  }

  // The register is checked automatically once a complete number has been typed.
  useEffect(() => {
    if (!listing.regulated || !looksComplete(markingType, number) || checkedNumber === number.trim()) return
    const timer = window.setTimeout(() => { void check(number) }, 700)
    return () => window.clearTimeout(timer)
  })

  if (!listing.regulated) return <section aria-labelledby="compliance-heading" className="grid gap-3"><SectionHeading id="compliance-heading" title="DTI-BPS compliance marking" /><StatusMessage>This material is not on the DTI-BPS list of regulated building and construction products, so no PS Mark or ICC sticker is requested.</StatusMessage></section>
  const rule = listing.regulatedRule
  const latest = listing.complianceSubmissions[0]
  const result = lookup.status === 'done' && lookup.number === number.trim() ? lookup.lookup : null
  const matched = result?.canVerifyAutomatically === true
  const canAskForReview = (lookup.status === 'done' && !matched) || lookup.status === 'failed'

  function changeType(type: MarkingType) {
    lookupRequest.current++
    setMarkingType(type); setNumber(''); setLookup({ status: 'idle' }); setReadNote(null); setConfirmed(false); setManualReview(false); setErrors({})
  }
  function changeNumber(value: string) {
    setNumber(value); setConfirmed(false); setManualReview(false)
    if (lookup.status !== 'idle' && lookup.number !== value.trim()) { lookupRequest.current++; setLookup({ status: 'idle' }) }
  }
  function editNumber() {
    numberInput.current?.focus(); numberInput.current?.select()
  }
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
      // ICC stickers carry a QR code; it is read in the browser from a QR image or a sticker photo.
      const qrPayload = path === 'QR' || (path === 'PHOTO_OCR' && markingType === 'ICC_STICKER') ? await decodeQrFromImage(file) : null
      const stored = await uploadComplianceEvidence(listing.id, path, file, qrPayload, markingType)
      setEvidence(current => [...current, stored])
      if (url) setThumbnails(current => ({ ...current, [stored.evidenceId]: url }))
      setPending(null)
      setErrors(current => { const next = { ...current }; delete next.evidence; return next })
      setReadNote(extractionNote(stored, copy.numberLabel, qrPayload !== null))
      const suggested = stored.extraction.suggestions.certificate_number
      if (suggested && path !== 'MANUAL') { changeNumber(suggested); void check(suggested) } else window.requestAnimationFrame(() => numberInput.current?.focus())
    } catch (cause) { setError(await readableCatalogError(cause)) } finally { setBusy(false) }
  }
  async function submit(event: FormEvent<HTMLFormElement>, reviewMode: 'AUTOMATIC' | 'MANUAL_REVIEW') {
    event.preventDefault(); setError(null)
    const local: Record<string, string> = {}
    if (number.trim().length < 3) local.certificate_number = `Enter the ${copy.numberLabel} as printed, for example ${copy.example}.`
    if (evidence.length === 0) local.evidence = `Upload a clear photo of the ${copy.name} above. It is kept privately as evidence.`
    if (!confirmed) local.confirmed = 'Confirm that you checked the number against the physical marking.'
    if (Object.keys(local).length) { setErrors(local); return }
    setBusy(true)
    try {
      onSubmitted(await submitCompliance(listing.id, {
        listingLockVersion: listing.lockVersion, path, evidenceIds: evidence.map(item => item.evidenceId), markingType, certificateNumber: number.trim(), reviewMode,
        reviewNote: reviewMode === 'MANUAL_REVIEW' ? reviewNote.trim() || null : null, batchNumber: batchNumber.trim() || null, confirmed: true,
      }))
      setEvidence([]); setNumber(''); setLookup({ status: 'idle' }); setReadNote(null); setConfirmed(false); setManualReview(false); setReviewNote(''); setBatchNumber('')
    } catch (cause) {
      // The register may have changed since the check: show the current result instead of an error.
      const refused = await refusedComplianceLookup(cause)
      if (refused) { setLookup({ status: 'done', number: number.trim(), lookup: refused }); setConfirmed(false); return }
      setErrors(await catalogFieldErrors(cause)); setError(await readableCatalogError(cause))
    } finally { setBusy(false) }
  }
  const confirmation = <>
    <label className="flex min-h-11 items-start gap-3 text-sm"><input type="checkbox" className="mt-1 h-5 w-5 accent-action-primary" checked={confirmed} aria-invalid={Boolean(errors.confirmed)} aria-describedby={errors.confirmed ? 'confirm-error' : undefined} onChange={event => setConfirmed(event.target.checked)} />I checked this {copy.numberLabel} against the physical marking on the product.</label>
    {errors.confirmed && <p id="confirm-error" className="text-sm text-status-error" role="alert">{errors.confirmed}</p>}
  </>
  return <section aria-labelledby="compliance-heading" className="grid gap-5">
    <SectionHeading id="compliance-heading" title="DTI-BPS compliance marking (required)" />
    <div className="flex items-start gap-3 rounded-control border border-amber-300 bg-amber-50 p-4 text-sm text-amber-900"><ShieldAlert size={20} className="mt-0.5 shrink-0" aria-hidden="true" /><p><strong>{rule?.productName ?? 'This product'}</strong>{rule?.referenceStandard ? ` (${rule.referenceStandard})` : ''} is a DTI-BPS regulated product. The listing can be published only after its PS Mark (locally manufactured) or ICC sticker (imported) is verified. MateryalPH review is a marketplace control, not a DTI-BPS certification.</p></div>
    <dl className="grid gap-3 text-sm sm:grid-cols-3"><div><dt className="text-text-secondary">Reference standard</dt><dd className="font-semibold">{rule?.referenceStandard ?? '—'}</dd></div><div><dt className="text-text-secondary">Technical regulation</dt><dd className="font-semibold">{rule?.technicalRegulation ?? '—'}</dd></div><div><dt className="text-text-secondary">Scope</dt><dd>{rule?.scope ?? '—'}</dd></div></dl>
    {rule && rule.markingRequirements.length > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-2 font-semibold">Marking requirements ({rule.markingRequirements.length})</summary><ul className="mt-2 list-disc space-y-1 pl-5">{rule.markingRequirements.map(item => <li key={item}>{item}</li>)}</ul></details>}
    <div className="flex flex-wrap items-center gap-3"><ListingBadge status={listing.complianceStatus} prefix="PS/ICC" />{latest?.latestReview?.reason && <span className="text-sm text-text-secondary">Reviewer: {latest.latestReview.reason}</span>}</div>
    {listing.complianceStatus === 'VERIFIED' ? <StatusMessage tone="success">Verified{latest?.latestReview?.source === 'SYSTEM_REGISTER_MATCH' ? ' through a match with the current DTI-BPS register' : ' by Product Compliance review'}. Editing the manufacturer, brand, model or material reopens verification.</StatusMessage>
      : listing.complianceStatus === 'PENDING_ADMIN_REVIEW' ? <StatusMessage>Your manual review request is waiting for Product Compliance. You can replace it with a corrected number below.</StatusMessage> : null}
    {!canSubmit ? <StatusMessage>Your role cannot submit PS/ICC evidence.</StatusMessage> : listing.complianceStatus !== 'VERIFIED' && <>
      <fieldset className="grid min-w-0 gap-2" disabled={busy}>
        <legend className="text-sm font-semibold">Marking on the product</legend>
        <div className="grid gap-3 sm:grid-cols-2">{(['PS_MARK', 'ICC_STICKER'] as const).map(type => { const checked = markingType === type; return <label key={type} className={`flex min-h-16 cursor-pointer items-start gap-3 rounded-control border p-3 ${checked ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}><input type="radio" name="marking_choice" className="mt-1 h-5 w-5 accent-action-primary" checked={checked} onChange={() => changeType(type)} /><span><span className="block font-semibold">{MARKING_COPY[type].name}</span><span className="block text-sm text-text-secondary">{type === 'PS_MARK' ? 'Locally manufactured · Philippine Standard' : 'Imported product · Import Commodity Clearance'}</span></span></label> })}</div>
      </fieldset>
      <fieldset className="grid min-w-0 gap-2" disabled={busy}>
        <legend className="text-sm font-semibold">How will you provide the marking?</legend>
        <div className="grid gap-3 md:grid-cols-3">{pathOptions.map(option => { const Icon = option.icon; const checked = path === option.value; return <label key={option.value} className={`flex min-h-11 cursor-pointer items-start gap-3 rounded-control border p-3 ${checked ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}`}><input type="radio" name="compliance_path" className="mt-1 h-5 w-5 shrink-0 accent-action-primary" checked={checked} onChange={() => { setPath(option.value); setEvidence([]); setReadNote(null); setConfirmed(false) }} /><span className="min-w-0"><span className="flex items-center gap-1.5 font-semibold"><Icon size={16} aria-hidden="true" />{option.label}</span><span className="block text-sm text-text-secondary">{option.description}</span></span></label> })}</div>
      </fieldset>
      <label hidden={Boolean(pending)} className={`grid cursor-pointer justify-items-center gap-2 rounded-surface border-2 border-dashed p-6 text-center transition-colors motion-reduce:transition-none ${busy ? 'opacity-60' : 'border-brand-orange-300 bg-brand-orange-50 hover:border-action-primary'}`}>
        <UploadCloud size={28} className="text-action-primary" aria-hidden="true" />
        <span className="font-semibold">{path === 'QR' ? 'Upload QR code image' : `Upload ${copy.name} marking photo`}</span>
        <span className="text-sm text-text-secondary">{path === 'QR' ? 'Photograph the ICC sticker straight on so the whole QR code is sharp and in frame.' : `Take a clear, well-lit photo showing the ${copy.numberLabel}.`} JPG, PNG or WebP up to 10 MB. You can check the photo before it is uploaded. Stored privately; never shown to Buyers.</span>
        <input ref={picker} type="file" accept={IMAGE_TYPES.join(',')} capture={path === 'PHOTO_OCR' ? 'environment' : undefined} disabled={busy} className="min-h-11 w-full min-w-0 max-w-xs text-sm" onChange={event => { choose(event.target.files?.[0]); event.target.value = '' }} />
      </label>
      {pending && <section aria-labelledby="pending-photo-heading" className="grid gap-4 rounded-surface border border-border-default p-4 sm:grid-cols-[minmax(0,18rem)_minmax(0,1fr)] sm:items-start">
        <div className="grid min-h-48 place-items-center overflow-hidden rounded-control border border-border-default bg-surface-canvas">{pending.url ? <img src={pending.url} alt={`Preview of ${pending.file.name}`} className="max-h-72 w-full object-contain" /> : <UploadCloud size={32} className="text-text-secondary" aria-hidden="true" />}</div>
        <div className="grid content-start gap-3">
          <h4 id="pending-photo-heading" className="text-lg font-semibold">Check the photo before uploading</h4>
          <p className="break-words text-sm text-text-secondary">{pending.file.name} · {Math.max(1, Math.round(pending.file.size / 1024))} KB</p>
          <p className="text-sm">Make sure the {path === 'QR' ? 'QR code' : `${copy.name} and its ${copy.numberLabel}`} is sharp, fully in frame and readable. A blurry or cropped photo cannot be read or reviewed.</p>
          <div className="flex flex-wrap gap-2"><Button disabled={busy} onClick={() => void upload()}>{busy ? 'Uploading and reading…' : 'Upload this photo'}</Button><Button variant="secondary" disabled={busy} onClick={() => picker.current?.click()}>Choose a different photo</Button><Button variant="quiet" disabled={busy} onClick={() => setPending(null)}>Cancel</Button></div>
        </div>
      </section>}
      {error && <StatusMessage tone="error">{error}</StatusMessage>}
      {evidence.length > 0 && <ul className="grid gap-3 text-sm sm:grid-cols-2" aria-label="Uploaded marking photos">{evidence.map((item, index) => <li key={item.evidenceId} className="flex min-w-0 items-center gap-3 rounded-control border border-border-default p-2">
        <span className="grid h-20 w-20 shrink-0 place-items-center overflow-hidden rounded-control bg-surface-canvas">{thumbnails[item.evidenceId] ? <img src={thumbnails[item.evidenceId]} alt={`Uploaded ${item.evidenceKind === 'QR_IMAGE' ? 'QR image' : 'marking photo'} ${index + 1}`} className="h-full w-full object-cover" /> : <CheckCircle2 size={20} className="text-status-success" aria-hidden="true" />}</span>
        <span className="min-w-0 flex-1"><span className="block font-semibold">{item.evidenceKind === 'QR_IMAGE' ? 'QR image' : 'Marking photo'} {index + 1}</span><span className="flex items-center gap-1 text-text-secondary"><CheckCircle2 size={14} className="text-status-success" aria-hidden="true" />Safety check {item.scanState === 'CLEAN' ? 'passed' : item.scanState.toLowerCase()} · {Math.max(1, Math.round(item.byteSize / 1024))} KB</span></span>
        <Button variant="quiet" disabled={busy} aria-label={`Remove ${item.evidenceKind === 'QR_IMAGE' ? 'QR image' : 'marking photo'} ${index + 1}`} onClick={() => { setEvidence(current => current.filter(entry => entry.evidenceId !== item.evidenceId)); setConfirmed(false) }}><Trash2 size={16} aria-hidden="true" /></Button>
      </li>)}</ul>}
      {errors.evidence && <p className="text-sm text-status-error" role="alert">{errors.evidence}</p>}

      <section aria-labelledby="marking-number-heading" className="grid gap-4 border-t border-border-default pt-5">
        <div><h4 id="marking-number-heading" className="text-lg font-semibold">{copy.numberLabel}</h4><p className="text-sm text-text-secondary">Only this number is needed. It is checked against the DTI-BPS {copy.list}, and the manufacturer or importer, product and brand are filled in from the matching record.</p></div>
        {readNote && <p className="text-sm" role="status">{readNote}</p>}
        <form className="flex flex-wrap items-start gap-3" noValidate onSubmit={event => { event.preventDefault(); void check(number) }}>
          <div className="min-w-0 flex-1 basis-64"><Field ref={numberInput} label={copy.numberLabel} name="certificate_number" value={number} required autoComplete="off" spellCheck={false} autoCapitalize="characters" placeholder={copy.example} maxLength={60} error={errors.certificate_number} hint={copy.where} disabled={busy} onChange={event => changeNumber(event.target.value)} /></div>
          <Button type="submit" variant="secondary" className="sm:mt-7" disabled={busy || lookup.status === 'checking'}><Search size={16} aria-hidden="true" />{lookup.status === 'checking' ? 'Checking…' : 'Check number'}</Button>
        </form>
        <div aria-live="polite" className="grid gap-4">
          {lookup.status === 'checking' && <p className="text-sm text-text-secondary">Checking the DTI-BPS {copy.list}…</p>}
          {result && matched && <div className="grid gap-3 rounded-control border border-status-success/40 bg-green-50 p-4 text-green-950">
            <p className="flex items-center gap-2 font-semibold"><CheckCircle2 size={18} aria-hidden="true" />Found in the DTI-BPS register</p>
            <p className="text-sm">{result.message}</p>
            <RegisterRecord lookup={result} />
          </div>}
          {result && !matched && <div className="grid gap-3 rounded-control border border-amber-300 bg-amber-50 p-4 text-amber-950">
            <p className="flex items-center gap-2 font-semibold"><AlertCircle size={18} aria-hidden="true" />{LOOKUP_TITLES[result.reason ?? ''] ?? 'Not confirmed by the register'}</p>
            <p className="text-sm">{result.message}</p>
            {result.record && <><p className="text-sm font-semibold">Record listed under this number</p><RegisterRecord lookup={result} /></>}
          </div>}
          {lookup.status === 'failed' && <StatusMessage tone="error">{lookup.message}</StatusMessage>}
          {canAskForReview && !manualReview && <div className="flex flex-wrap gap-2">
            <Button variant="secondary" disabled={busy} onClick={editNumber}><Pencil size={16} aria-hidden="true" />Edit number</Button>
            <Button variant="secondary" disabled={busy} onClick={() => void check(number)}><RefreshCw size={16} aria-hidden="true" />Try again</Button>
            <Button variant="outline" disabled={busy} onClick={() => { setManualReview(true); setConfirmed(false) }}><ClipboardCheck size={16} aria-hidden="true" />Request manual review</Button>
          </div>}
        </div>
      </section>

      {matched && <form className="grid gap-4 border-t border-border-default pt-5" noValidate onSubmit={event => void submit(event, 'AUTOMATIC')}>
        <h4 className="text-lg font-semibold">Submit for automatic verification</h4>
        <div className="max-w-sm"><Field label="Batch or lot number (optional)" name="batch_number" value={batchNumber} maxLength={60} onChange={event => setBatchNumber(event.target.value)} /></div>
        {confirmation}
        <Button type="submit" className="w-fit" disabled={busy}>{busy ? 'Submitting…' : 'Submit for automatic verification'}</Button>
      </form>}
      {manualReview && <form className="grid gap-4 border-t border-border-default pt-5" noValidate onSubmit={event => void submit(event, 'MANUAL_REVIEW')} aria-labelledby="manual-review-heading">
        <h4 id="manual-review-heading" className="text-lg font-semibold">Request manual review</h4>
        <p className="text-sm">Product Compliance staff will check {copy.numberLabel} <strong>{number.trim() || '—'}</strong> and your photo against DTI-BPS records. The listing stays unpublished until they decide, and you are notified of the outcome.</p>
        <label className="grid gap-2 text-sm font-semibold" htmlFor="review_note">Note for the reviewer (optional)
          <textarea id="review_note" name="review_note" rows={3} maxLength={500} value={reviewNote} className="min-h-24 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 py-2 text-base font-normal" placeholder="For example: licence issued this month and not yet on the list." onChange={event => setReviewNote(event.target.value)} />
        </label>
        {confirmation}
        <div className="flex flex-wrap gap-2"><Button type="submit" disabled={busy}>{busy ? 'Sending…' : 'Send for manual review'}</Button><Button variant="quiet" disabled={busy} onClick={() => setManualReview(false)}>Cancel</Button></div>
      </form>}
    </>}
    {listing.complianceSubmissions.length > 0 && <section aria-labelledby="submission-history" className="grid gap-2 border-t border-border-default pt-5"><h4 id="submission-history" className="font-semibold">Submission history</h4><ul className="divide-y divide-border-default text-sm">{listing.complianceSubmissions.map(item => <li key={item.id} className="flex flex-wrap items-center gap-x-4 gap-y-1 py-2"><span className="font-semibold">Version {item.version}</span><ListingState status={item.status} /><span className="text-text-secondary">{statusLabel(item.path)}{item.reviewMode === 'MANUAL_REVIEW' ? ' · Manual review requested' : ''}{item.latestReview ? ` · ${item.latestReview.source === 'SYSTEM_REGISTER_MATCH' ? 'Register match' : 'Admin review'}${item.latestReview.reason ? `: ${item.latestReview.reason}` : ''}` : ''}</span></li>)}</ul></section>}
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
